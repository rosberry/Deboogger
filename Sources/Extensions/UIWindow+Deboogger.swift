//
// Copyright (c) 2019 Rosberry. All rights reserved.
//

import UIKit

extension UIWindow {

//    @objc private func swizzled_init(frame: CGRect) {
//        swizzled_init(frame: frame)
//        setupGestureRecognizer()
//    }
//
//    @objc private func swizzled_init(coder: NSCoder) {
//        swizzled_init(coder: coder)
//        setupGestureRecognizer()
//    }

    @objc private func setupGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(showDeboogger))
        recognizer.numberOfTapsRequired = 2
        recognizer.numberOfTouchesRequired = 4
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
