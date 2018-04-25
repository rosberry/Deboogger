//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    public static let DebooggerWillShow: NSNotification.Name = .init(rawValue: "DebooggerWillShow")
    public static let DebooggerDidShow: NSNotification.Name = .init(rawValue: "DebooggerDidShow")
    public static let DebooggerWillHide: NSNotification.Name = .init(rawValue: "DebooggerWillHide")
    public static let DebooggerDidHide: NSNotification.Name = .init(rawValue: "DebooggerDidHide")
}

let AssistiveButtonWindowLevel: UIWindowLevel = UIWindowLevelAlert + 1
let PluginControllerWindowLevel: UIWindowLevel = UIWindowLevelStatusBar - 1

private final class AssistiveButtonPresenterViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        if let vc = UIApplication.shared.keyWindow?.rootViewController, vc !== self {
            return vc.prefersStatusBarHidden
        }
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let vc = UIApplication.shared.keyWindow?.rootViewController, vc !== self {
            return vc.preferredStatusBarStyle
        }
        return .lightContent
    }
}

public final class Deboogger {

    public static let shared = Deboogger()

    private weak var rootViewController: UIViewController?
    private var assistiveButtonPresenterViewController = AssistiveButtonPresenterViewController()

    private lazy var assistiveButtonWindow: UIWindow = {
        let size = AssistiveButton.Layout.size
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: size, height: size))
        window.windowLevel = AssistiveButtonWindowLevel
        window.rootViewController = self.assistiveButtonPresenterViewController
        window.isHidden = true
        return window
    }()

    private weak var pluginViewController: PluginViewController?

    private init() {}

    // MARK: - Configurations

    public static func configure(with plugins: [Plugin]) {
        shared.configure(with: PluginsConfiguration(plugins: plugins))
    }

    public static func configure(with plugins: Plugin...) {
        configure(with: plugins)
    }

    public static func configure(with sections: [Section]) {
        shared.configure(with: SectionsConfiguration(sections: sections))
    }

    public static func configure(with sections: Section...) {
        configure(with: sections)
    }

    // MARK: - Appearance

    public func reload() {
        pluginViewController?.tableView.reloadData()
    }
    
    public func close() {
        rootViewController?.beginAppearanceTransition(true, animated: true)
        NotificationCenter.default.post(name: .DebooggerWillHide, object: nil)

        pluginViewController?.dismiss(animated: true, completion: { [unowned self] in
            self.assistiveButtonWindow.isHidden = false
            self.rootViewController?.endAppearanceTransition()
            NotificationCenter.default.post(name: .DebooggerDidHide, object: nil)
        })
    }

    // MARK: - Helpers

    private func configure(with configuration: Configuration) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

            let button = AssistiveButton(tapHandler: { [unowned self] in
                self.rootViewController = UIApplication.shared.keyWindow?.rootViewController

                let pluginViewController = PluginViewController(configuration: configuration)
                pluginViewController.closeEventHandler = {
                    self.close()
                }

                let navigationController = UINavigationController(rootViewController: pluginViewController)
                self.pluginViewController = pluginViewController

                self.rootViewController?.beginAppearanceTransition(false, animated: true)
                NotificationCenter.default.post(name: .DebooggerWillShow, object: nil)

                self.assistiveButtonWindow.isHidden = true
                navigationController.present {
                    self.rootViewController?.endAppearanceTransition()
                    NotificationCenter.default.post(name: .DebooggerDidShow, object: nil)
                }
            })

            self.assistiveButtonWindow.isHidden = false
            self.assistiveButtonWindow.addSubview(button)
        }
    }
}
