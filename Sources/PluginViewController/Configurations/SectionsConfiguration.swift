//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import Foundation

final class SectionsConfiguration: NSObject, Configuration {

    let sections: [Section]
    var sectionItems: [SectionItem] = []

    weak var tableView: UITableView?
    weak var delegate: ConfigurationDelegate?

    init(sections: [Section]) {
        self.sections = sections
    }

    func configure() {
        let isSingleSection = sections.count == 1
        sectionItems = sections.map({ (section: Section) -> SectionItem in
            let title: String?
            let cellItems: [CellItem]

            switch section.style {
            case .plain:
                title = section.title
                cellItems = pluginCellItems(for: section)
            case .nested:
                title = nil
                cellItems = isSingleSection ?
                    pluginCellItems(for: section) :
                    navigationCellItems(for: section)
            }

            return SectionItem(title: title, section: section, cellItems: cellItems)
        })
    }

    private func register(_ cellClass: UITableViewCell.Type) {
        tableView?.register(cellClass, forCellReuseIdentifier: cellClass.description())
    }

    private func pluginCellItems(for section: Section) -> [CellItem] {
        return section.plugins.map({ (plugin: Plugin) -> CellItem in
            register(plugin.cellClass)
            return CellItem(plugin: plugin)
        })
    }

    private func navigationCellItems(for section: Section) -> [CellItem] {
        let plugin = SectionNavigationPlugin(title: section.title, action: { [weak self] in
            guard let self = self else {
                return
            }

            let configuration = SectionsConfiguration(sections: [section])
            self.delegate?.configuration(self, didRequest: configuration, withTitle: section.title)
        })
        register(plugin.cellClass)

        return [CellItem(plugin: plugin)]
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionItems[section].cellItems.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sectionItems[indexPath.section].cellItems[indexPath.row]
        let identifier = item.plugin.cellClass.description()
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? BaseTableViewCell
        cell?.configure(with: item.plugin)
        return cell ?? UITableViewCell()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionItems[section].title
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let plugin = sectionItems[indexPath.section].cellItems[indexPath.row].plugin
        plugin.selectionAction()
    }
}
