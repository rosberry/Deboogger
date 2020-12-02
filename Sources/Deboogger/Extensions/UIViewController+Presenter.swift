//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

private enum AssociationKeys {
    static var windowType: UInt8 = 0
    static var presenterType: UInt8 = 0
}

extension UIViewController {
    
    private var alertWindow: UIWindow? {
        get {
            return objc_getAssociatedObject(self, &AssociationKeys.windowType) as? UIWindow
        }
        set {
            objc_setAssociatedObject(self, &AssociationKeys.windowType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var presenter: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociationKeys.presenterType) as? UIViewController
        }
        set {
            objc_setAssociatedObject(self, &AssociationKeys.presenterType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIViewController {
    
    func present(completion: @escaping () -> Void) {
        presenter = UIViewController()
        
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow?.windowLevel = PluginControllerWindowLevel
        alertWindow?.rootViewController = presenter
        alertWindow?.isHidden = false

        presenter?.present(self, animated: true, completion: {
            completion()
        })
    }
}
