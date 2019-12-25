//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

final class PluginViewController: UIViewController {

    var closeEventHandler: (() -> Void)?

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = configuration
        tableView.dataSource = configuration
        tableView.estimatedRowHeight = 100
        tableView.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 0)
        return tableView
    }()

    private let configuration: Configuration

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    init(configuration: Configuration, title: String? = nil) {
        self.configuration = configuration

        super.init(nibName: nil, bundle: nil)
        self.title = title

        configuration.delegate = self
        configuration.tableView = tableView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let appInfo = Bundle.main.infoDictionary,
           let shortVersionString = appInfo["CFBundleShortVersionString"] as? String,
           let bundleVersion = appInfo["CFBundleVersion"] as? String,
           let bundleName = appInfo["CFBundleName"] as? String {
            let appVersion = "\(bundleName)\n\(shortVersionString) (\(bundleVersion))"

            let titleLabel = UILabel()
            titleLabel.text = title ?? appVersion
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            titleLabel.sizeToFit()

            navigationItem.titleView = titleLabel
        }

        view.backgroundColor = .white
        view.addSubview(tableView)

        configuration.configure()

        if navigationController?.viewControllers.first === self {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                               target: self,
                                                               action: #selector(closeButtonPressed))
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🛠",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(settingsButtonPressed))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: Actions
    
    @objc private func closeButtonPressed() {
        closeEventHandler?()
    }

    @objc private func settingsButtonPressed() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsURL)
            } else {
                UIApplication.shared.openURL(settingsURL)
            }
        }
    }
}

// MARK: - ConfigurationDelegate

extension PluginViewController: ConfigurationDelegate {

    func configuration(_ sender: Configuration, didRequest childConfiguration: Configuration, withTitle title: String?) {
        let controller = PluginViewController(configuration: childConfiguration, title: title)
        navigationController?.pushViewController(controller, animated: true)
    }
}
