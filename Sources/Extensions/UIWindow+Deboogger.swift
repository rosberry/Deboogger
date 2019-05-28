//
// Copyright (c) 2019 Rosberry. All rights reserved.
//

import UIKit

private enum AssociationKeys {
    static var debooggerGestureRecognizer: UInt8 = 0
}

extension UIWindow {

    public var debooggerGestureRecognizer: UITapGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &AssociationKeys.debooggerGestureRecognizer) as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &AssociationKeys.debooggerGestureRecognizer, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    @objc private func setupGestureRecognizer() {
        #if targetEnvironment(simulator)
            return
        #endif

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(showDeboogger))
        recognizer.requiresExclusiveTouchType = false
        addGestureRecognizer(recognizer)

        Deboogger.shared.setup(recognizer)
        debooggerGestureRecognizer = recognizer
    }

    // MARK: Show/Hide

    @objc private func showDeboogger() {
        Deboogger.shared.show()
    }
}
