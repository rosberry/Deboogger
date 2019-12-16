//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import Foundation

final class SectionsConfiguration: NSObject, Configuration {

    let plugins: [Plugin]

    var sections: [NavigationPlugin] = []
    var tableViewItems: [PluginItem] = []
    var filteredTableViewItems: [PluginItem] = []
    var favoritesSection: NavigationPlugin = SectionPlugin(title: "Favorites", style: .plain, plugins: [])
    var favoritesPluginItems: [PluginItem] = []

    weak var tableView: UITableView?
    weak var delegate: ConfigurationDelegate?

    init(plugins: [Plugin]) {
        self.plugins = plugins
    }

    func configure() {
        let favoritePlugins = favoritesPluginItems.map { item -> Plugin in
            item.plugin
        }
        sections = makeSections(for: plugins)
        if favoritePlugins.isEmpty == false {
            sections.insert(SectionPlugin(title: "Favorites", style: .plain, plugins: favoritePlugins), at: 0)
        }
        tableViewItems = sections.map { (section: NavigationPlugin) -> PluginItem in
            return makePluginItem(for: section)
        }
        filteredTableViewItems = tableViewItems
    }

    func filterData(with text: String) {
        defer {
            tableView?.reloadData()
        }
        guard text.isEmpty == false else {
            filteredTableViewItems = tableViewItems
            return
        }

        filteredTableViewItems = tableViewItems.compactMap { pluginItem -> PluginItem? in
            let filteredChildren = pluginItem.children.filter { childPlugin -> Bool in
                childPlugin.plugin.keywords.lowercased().contains(text)
            }
            return filteredChildren.isEmpty ? nil : PluginItem(title: pluginItem.title,
                                                               plugin: pluginItem.plugin,
                                                               children: filteredChildren)
        }
    }

    // MARK: - Private

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

    private func childPluginItem(for indexPath: IndexPath) -> PluginItem {
        filteredTableViewItems[indexPath.section].children[indexPath.row]
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTableViewItems[section].children.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredTableViewItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = childPluginItem(for: indexPath)
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
        let plugin = childPluginItem(for: indexPath).plugin
        plugin.selectionAction()

        if let section = plugin as? NavigationPlugin {
            let configuration = SectionsConfiguration(plugins: section.plugins)
            delegate?.configuration(self, didRequest: configuration, withTitle: section.title.string)
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favoriteAction = UITableViewRowAction(style: .default, title: "⭐️" , handler: { action, indexPath in
            let item = self.childPluginItem(for: indexPath)
            self.favoritesPluginItems.append(item)
            self.configure()
            self.tableView?.reloadData()
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "🗑" , handler: { action, indexPath in
            let item = self.childPluginItem(for: indexPath)
            self.favoritesPluginItems.removeAll { pluginItem -> Bool in
                pluginItem == item
            }
            self.configure()
            tableView.reloadData()
        })
        favoriteAction.backgroundColor = .systemBlue
        let isFavorite = favoritesPluginItems.contains { pluginItem -> Bool in
            pluginItem == childPluginItem(for: indexPath)
        }
        return isFavorite ? [deleteAction] : [favoriteAction]
    }
}
