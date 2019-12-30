//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import Foundation

final class SectionsConfiguration: NSObject, Configuration {

    let plugins: [Plugin]

    var sections: [NavigationPlugin] = []
    var tableViewItems: [PluginItem] = []

    private var filteredTableViewItems: [PluginItem] = []
    private var flatPlugins: [Plugin] = []

    weak var tableView: UITableView?
    weak var delegate: ConfigurationDelegate?

    init(plugins: [Plugin]) {
        self.plugins = plugins
    }

    func configure() {
        sections = self.makeSections(for: plugins)
        tableViewItems = sections.map { (section: NavigationPlugin) -> PluginItem in
            return makePluginItem(for: section)
        }
        filteredTableViewItems = tableViewItems
        flatPlugins = tableViewItems.flatMap { pluginItem in
            collectPlugins(in: pluginItem.plugin, sectionTitle: pluginItem.title)
        }
    }

    func filterData(with text: String) {
        defer {
            tableView?.reloadData()
        }
        guard text.isEmpty == false else {
            filteredTableViewItems = tableViewItems
            return
        }

        let filteredFlatPlugins = flatPlugins.filter { plugin in
            plugin.keywords.lowercased().contains(text)
        }
        let resultPluginItems = filteredFlatPlugins.map { plugin -> PluginItem in
            PluginItem(title: plugin.title.string, plugin: plugin, children: [])
        }

        filteredTableViewItems = [PluginItem(title: "Search result",
                                             plugin: SectionPlugin(plugins: filteredFlatPlugins),
                                             children: resultPluginItems)]
    }

    // MARK: - Private

    private func collectPlugins(in plugin: Plugin, sectionTitle: String?) -> [Plugin] {
        var result: [Plugin] = []

        if let navigationPlugin = plugin as? NavigationPlugin {
            navigationPlugin.plugins.forEach { childPlugin in
                result.append(contentsOf: collectPlugins(in: childPlugin, sectionTitle: navigationPlugin.title.string))
            }
        }
        else {
            result.append(plugin)
        }

        return result
    }

    private func makeSections(for plugins: [Plugin]) -> [NavigationPlugin] {
        var sections: [NavigationPlugin] = []
        var sectionlessPlugins: [Plugin] = []
        plugins.forEach { (plugin: Plugin) in
            guard let section = plugin as? NavigationPlugin else {
                sectionlessPlugins.append(plugin)
                return
            }

            if sectionlessPlugins.isEmpty == false {
                sections.append(SectionPlugin(plugins: sectionlessPlugins))
                sectionlessPlugins.removeAll()
            }

            sections.append(section)
        }

        if sectionlessPlugins.isEmpty == false {
            sections.append(SectionPlugin(plugins: sectionlessPlugins))
        }

        return sections
    }

    private func register(_ cellClass: UITableViewCell.Type) {
        tableView?.register(cellClass, forCellReuseIdentifier: cellClass.description())
    }

    private func makePluginItem(for section: NavigationPlugin) -> PluginItem {
        let isSingleSection = sections.count == 1
        let children = makePluginItems(for: section.plugins)

        register(section.cellClass)
        switch section.style {
        case .plain:
            return PluginItem(title: section.title.string, plugin: section, children: children)
        case .nested:
            return isSingleSection ?
                PluginItem(title: nil, plugin: section, children: children) :
                makeNavigationItem(for: section)
        }
    }

    private func makePluginItems(for plugins: [Plugin]) -> [PluginItem] {
        return plugins.map { (plugin: Plugin) -> PluginItem in
            register(plugin.cellClass)
            guard let section = plugin as? NavigationPlugin else {
                return PluginItem(title: plugin.title.string, plugin: plugin, children: [])
            }

            switch section.style {
            case .plain:
                return makePluginItem(for: section)
            case .nested:
                return makeNavigationItem(for: section)
            }
        }
    }

    private func makeNavigationItem(for section: NavigationPlugin) -> PluginItem {
        return PluginItem(title: nil, plugin: section, children: [
            PluginItem(title: section.title.string, plugin: section, children: [])
        ])
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTableViewItems[section].children.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredTableViewItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = filteredTableViewItems[indexPath.section].children[indexPath.row]
        let identifier = item.plugin.cellClass.description()
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? BaseTableViewCell
        cell?.configure(with: item.plugin)
        return cell ?? UITableViewCell()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = filteredTableViewItems[section]
        return item.title
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let plugin = filteredTableViewItems[indexPath.section].children[indexPath.row].plugin
        plugin.selectionAction()

        if let section = plugin as? NavigationPlugin {
            let configuration = SectionsConfiguration(plugins: section.plugins)
            delegate?.configuration(self, didRequest: configuration, withTitle: section.title.string)
        }
    }
}
