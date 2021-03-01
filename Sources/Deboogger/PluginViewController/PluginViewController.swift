//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

final class PluginViewController: UIViewController {

    var closeEventHandler: (() -> Void)?


    private let configuration: Configuration

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Subviews

    private(set) lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.returnKeyType = .done
        view.delegate = self
        view.isHidden = true
        return view
    }()

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = configuration
        tableView.dataSource = configuration
        tableView.estimatedRowHeight = 100
        tableView.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()

    // MARK: - Lifecycle

    init(configuration: Configuration, title: String? = nil) {
        self.configuration = configuration

        super.init(nibName: nil, bundle: nil)
        self.title = title

        configuration.delegate = self
        configuration.tableView = tableView

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
        view.addSubview(searchBar)
        view.addSubview(tableView)

        configuration.configure()

        if navigationController?.viewControllers.first === self {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                               target: self,
                                                               action: #selector(closeButtonPressed))
            searchBar.isHidden = false
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🛠",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(settingsButtonPressed))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var topInset: CGFloat = 0
        if #available(iOS 11.0, *) {
            topInset = view.safeAreaInsets.top
        }
        let searchBarSize = searchBar.isHidden ? .zero : searchBar.sizeThatFits(view.bounds.size)
        searchBar.frame = .init(origin: CGPoint(x: 0, y: topInset), size: searchBarSize)
        tableView.frame = CGRect(x: 0,
                                 y: searchBar.frame.maxY,
                                 width: view.bounds.width,
                                 height: view.bounds.height - searchBar.frame.maxY)
    }
    
    // MARK: Actions
    
    @objc private func closeButtonPressed() {
        closeEventHandler?()
    }

    @objc private func keyboardDidShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }

        tableView.contentInset.bottom = endFrame.height
        tableView.scrollIndicatorInsets = tableView.contentInset
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        var bottomInset: CGFloat = 0
        if #available(iOS 11.0, *) {
            bottomInset = view.safeAreaInsets.bottom
        }
        tableView.contentInset.bottom = bottomInset
        tableView.scrollIndicatorInsets = tableView.contentInset
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

// MARK: - UISearchBarDelegate

extension PluginViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        (configuration as? SectionsConfiguration)?.filterData(with: searchText.trimmingCharacters(in: .whitespaces).lowercased())
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.searchBar(searchBar, textDidChange: "")
        view.endEditing(true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
