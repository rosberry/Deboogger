//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation

final class SectionsConfiguration: NSObject, Configuration {

    let sections: [Section]

    weak var tableView: UITableView?
    weak var delegate: ConfigurationDelegate?

    init(sections: [Section]) {
        self.sections = sections
    }

    func configure() {
        tableView?.register(SectionTableViewCell.self, forCellReuseIdentifier: SectionTableViewCell.self.description())
        sections.flatMap { section in
            return section.plugins
        }.forEach { plugin in
            tableView?.register(plugin.cellClass, forCellReuseIdentifier: plugin.cellClass.description())
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.style {
        case .plain:
            return section.plugins.count
        case .nested:
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        if section.style == .nested {
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionTableViewCell.self.description(), for: indexPath)
            (cell as? SectionTableViewCell)?.configure(with: section)
            return cell
        }

        let plugin = section.plugins[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: plugin.cellClass.description(), for: indexPath) as? BaseTableViewCell
        cell?.configure(with: plugin)
        return cell ?? UITableViewCell()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        switch section.style {
        case .plain:
            return section.title
        case .nested:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = sections[indexPath.section]
        if section.style == .nested {
            let configuration = PluginsConfiguration(plugins: section.plugins)
            delegate?.configuration(self, didRequest: configuration, withTitle: section.title)
            return
        }

        let plugin = section.plugins[indexPath.row]
        plugin.selectionAction()
    }
}
