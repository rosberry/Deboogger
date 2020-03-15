//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2020 Rosberry. All rights reserved.
//

import Foundation

public extension Deboogger {

    static var userDefaults: UserDefaults {
        UserDefaults(suiteName: "com.rosberry.Deboogger") ?? .standard
    }

    static subscript(defaults key: String) -> Bool {
        get {
            userDefaults.bool(forKey: key)
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }

    static var shouldShowDebooggerButton: Bool {
        get {
            self[defaults: #function]
        }
        set {
            self[defaults: #function] = newValue
        }
    }
}
