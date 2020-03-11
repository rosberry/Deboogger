//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2020 Rosberry. All rights reserved.
//

import Foundation

public extension UserDefaults {

    static var deboogger: UserDefaults {
        UserDefaults(suiteName: "com.otbivnoe.Deboogger") ?? .standard
    }

    subscript(_ key: String) -> Bool {
        get {
            bool(forKey: key)
        }
        set {
            set(newValue, forKey: key)
        }
    }
}
