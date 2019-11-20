//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation

final class PluginsConfiguration: NSObject, Configuration {

    let plugins: [Plugin]

    weak var tableView: UITableView?
    weak var delegate: ConfigurationDelegate?

    init(plugins: [Plugin]) {
        self.plugins = plugins
    }

    func configure() {
        plugins.forEach { plugin in
            tableView?.register(plugin.cellClass, forCellReuseIdentifier: plugin.cellClass.description())
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plugins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plugin = plugins[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: plugin.cellClass.description(), for: indexPath) as? BaseTableViewCell
        cell?.configure(with: plugin)
        return cell ?? UITableViewCell()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plugin = plugins[indexPath.row]
        plugin.selectionAction()
    }
}
