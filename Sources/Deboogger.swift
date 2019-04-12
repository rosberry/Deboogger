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

let AssistiveButtonWindowLevel: UIWindow.Level = UIWindow.Level.alert + 1
let PluginControllerWindowLevel: UIWindow.Level = UIWindow.Level.statusBar - 1

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

    weak var pluginViewController: PluginViewController?
    public var viewController: UIViewController? {
        return pluginViewController
    }
    public var navigationController: UINavigationController? {
        return pluginViewController?.navigationController
    }

    private var configuration: Configuration?
    private var isShowing: Bool = false

    private var _shouldShowAssistiveButton: Bool = false
    var shouldShowAssistiveButton: Bool {
        get {
            #if targetEnvironment(simulator)
                return true
            #endif
            return _shouldShowAssistiveButton
        }
        set {
            _shouldShowAssistiveButton = newValue
        }
    }

    private init() {}

    // MARK: - Configurations

    public static func configure(with plugins: [Plugin]) {
        #if targetEnvironment(simulator)
            shared.configure(with: PluginsConfiguration(plugins: plugins))
        #else
            let section = Section(title: "App plugins", plugins: plugins)
            configure(with: [section])
        #endif
    }

    public static func configure(with plugins: Plugin...) {
        configure(with: plugins)
    }

    public static func configure(with sections: Section...) {
        configure(with: sections)
    }

    public static func configure(with sections: [Section]) {
        #if targetEnvironment(simulator)
            shared.configure(with: SectionsConfiguration(sections: sections))
        #else
            var adjustedSections = sections
            adjustedSections.insert(shared.makeDefaultSection(), at: 0)
            shared.configure(with: SectionsConfiguration(sections: adjustedSections))
        #endif
    }

    // MARK: - Appearance

    public func reload() {
        pluginViewController?.tableView.reloadData()
    }
    
    public func close() {
        rootViewController?.beginAppearanceTransition(true, animated: true)
        NotificationCenter.default.post(name: .DebooggerWillHide, object: nil)

        pluginViewController?.dismiss(animated: true, completion: { [unowned self] in
            self.isShowing = false
            self.assistiveButtonWindow.isHidden = !self.shouldShowAssistiveButton
            self.rootViewController?.endAppearanceTransition()
            NotificationCenter.default.post(name: .DebooggerDidHide, object: nil)
        })
    }

    public func show() {
        if isShowing {
            close()
            return
        }

        guard let configuration = configuration else {
            return
        }
        isShowing = true

        let pluginViewController = PluginViewController(configuration: configuration)
        pluginViewController.closeEventHandler = { [weak self] in
            self?.close()
        }

        let navigationController = UINavigationController(rootViewController: pluginViewController)
        self.pluginViewController = pluginViewController

        self.rootViewController?.beginAppearanceTransition(false, animated: true)
        NotificationCenter.default.post(name: .DebooggerWillShow, object: nil)

        navigationController.present {
            self.rootViewController?.endAppearanceTransition()
            NotificationCenter.default.post(name: .DebooggerDidShow, object: nil)
        }
        self.assistiveButtonWindow.isHidden = true
    }

    // MARK: - Helpers

    private func configure(with configuration: Configuration) {
        self.configuration = configuration

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

            let button = AssistiveButton(tapHandler: { [weak self] in
                self?.show()
            })

            self.assistiveButtonWindow.isHidden = !self.shouldShowAssistiveButton
            self.assistiveButtonWindow.addSubview(button)
        }
    }

    // MARK: - Default section

    private func makeDefaultSection() -> Section {
        return Section(title: "Deboogger settings", plugins: [DebooggerButtonPlugin()])
    }
}
