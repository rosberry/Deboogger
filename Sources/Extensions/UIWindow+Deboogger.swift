//
// Copyright (c) 2019 Rosberry. All rights reserved.
//

import UIKit

extension UIWindow {

    private enum Constants {
        static let numberOfTouches = 4
        static let numberOfTaps = 2
    }

    @objc private func setupGestureRecognizer() {
        #if targetEnvironment(simulator)
            return
        #endif

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(showDeboogger))
        recognizer.numberOfTapsRequired = Constants.numberOfTaps
        recognizer.numberOfTouchesRequired = Constants.numberOfTouches
        recognizer.requiresExclusiveTouchType = false
        addGestureRecognizer(recognizer)
    }

    // MARK: Show/Hide

    @objc private func showDeboogger() {
        let deboogger = Deboogger.shared
        guard let configuration = deboogger.configuration else {
            return
        }

        let pluginViewController = PluginViewController(configuration: configuration)
        pluginViewController.closeEventHandler = { [weak deboogger] in
            deboogger?.close()
        }

        let navigationController = UINavigationController(rootViewController: pluginViewController)
        deboogger.pluginViewController = pluginViewController

        self.rootViewController?.beginAppearanceTransition(false, animated: true)
        NotificationCenter.default.post(name: .DebooggerWillShow, object: nil)

        navigationController.present {
            self.rootViewController?.endAppearanceTransition()
            NotificationCenter.default.post(name: .DebooggerDidShow, object: nil)
        }
    }
}
