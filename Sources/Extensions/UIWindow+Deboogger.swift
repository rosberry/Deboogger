//
// Copyright (c) 2019 Rosberry. All rights reserved.
//

import UIKit

private enum AssociationKeys {
    static var debooggerGestureRecognizer: UInt8 = 0
}

extension UIWindow {

    private enum Constants {
        static let numberOfTouches = 4
        static let numberOfTaps = 2
    }

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
        recognizer.numberOfTapsRequired = Constants.numberOfTaps
        recognizer.numberOfTouchesRequired = Constants.numberOfTouches
        recognizer.requiresExclusiveTouchType = false
        addGestureRecognizer(recognizer)

        debooggerGestureRecognizer = recognizer
    }

    // MARK: Show/Hide

    @objc private func showDeboogger() {
        Deboogger.shared.show()
    }
}
