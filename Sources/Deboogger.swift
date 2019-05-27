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

public struct DebooggerGesture {
    public let numberOfTouches: Int
    public let numberOfTaps: Int

    public init(numberOfTouches: Int, numberOfTaps: Int) {
        self.numberOfTouches = numberOfTouches
        self.numberOfTaps = numberOfTaps
    }
}

public final class Deboogger {

    public static let shared = Deboogger()

    private weak var rootViewController: UIViewController?
    private var assistiveButtonPresenterViewController = AssistiveButtonPresenterViewController()
    private weak var assistiveButton: UIButton?

    private var gesture: DebooggerGesture = .init(numberOfTouches: 2,
                                                  numberOfTaps: 2)

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

    public static func configure(with plugins: [Plugin], gesture: DebooggerGesture = .init(numberOfTouches: 2,
                                                                                           numberOfTaps: 2)) {
        #if targetEnvironment(simulator)
            shared.configure(with: PluginsConfiguration(plugins: plugins), gesture: gesture)
        #else
            let section = Section(title: "App plugins", plugins: plugins)
            configure(with: [section], gesture: gesture)
        #endif
    }

    public static func configure(with plugins: Plugin..., gesture: DebooggerGesture = .init(numberOfTouches: 2,
                                                                                            numberOfTaps: 2)) {
        configure(with: plugins, gesture: gesture)
    }

    public static func configure(with sections: Section..., gesture: DebooggerGesture = .init(numberOfTouches: 2,
                                                                                              numberOfTaps: 2)) {
        configure(with: sections, gesture: gesture)
    }

    public static func configure(with sections: [Section], gesture: DebooggerGesture = .init(numberOfTouches: 2,
                                                                                             numberOfTaps: 2)) {
        #if targetEnvironment(simulator)
            shared.configure(with: SectionsConfiguration(sections: sections), gesture: gesture)
        #else
            var adjustedSections = sections
            adjustedSections.insert(shared.makeDefaultSection(), at: 0)
            shared.configure(with: SectionsConfiguration(sections: adjustedSections), gesture: gesture)
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
            self.rootViewController?.endAppearanceTransition()
            self.assistiveButtonWindow.isHidden = !self.shouldShowAssistiveButton
            if let assistiveButton = self.assistiveButton {
                assistiveButton.removeFromSuperview()
                self.assistiveButtonWindow.addSubview(assistiveButton)
            }

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

        rootViewController?.beginAppearanceTransition(false, animated: true)
        NotificationCenter.default.post(name: .DebooggerWillShow, object: nil)

        navigationController.present {
            self.rootViewController?.endAppearanceTransition()
            NotificationCenter.default.post(name: .DebooggerDidShow, object: nil)
        }
        assistiveButtonWindow.isHidden = true

        setup(gesture)
    }

    // MARK: - Helpers

    private func configure(with configuration: Configuration, gesture: DebooggerGesture) {
        self.configuration = configuration
        setup(gesture)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let button = AssistiveButton(tapHandler: { [weak self] in
                self?.show()
            })
            self.assistiveButtonWindow.isHidden = !self.shouldShowAssistiveButton
            self.assistiveButtonWindow.addSubview(button)
            self.assistiveButton = button
        }
    }

    private func setup(_ gesture: DebooggerGesture) {
        self.gesture = gesture
        for window in UIApplication.shared.windows {
            window.debooggerGestureRecognizer?.numberOfTapsRequired = gesture.numberOfTaps
            window.debooggerGestureRecognizer?.numberOfTouchesRequired = gesture.numberOfTouches
        }
    }

    // MARK: - Default section

    private func makeDefaultSection() -> Section {
        return Section(title: "Deboogger settings", plugins: [DebooggerButtonPlugin()])
    }
}
