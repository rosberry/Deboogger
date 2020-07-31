//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import Foundation

public extension Deboogger {

    private enum Constants {
        static let domain = "com.rosberry.Deboogger"
    }

    class Storage {

        public subscript(defaults key: String) -> Any? {
            get {
                userDefaults.object(forKey: key)
            }
            set {
                userDefaults.set(newValue, forKey: key)
            }
        }

        public subscript(keychain key: String) -> String? {
            get {
                try? keychain.readPassword(forKey: key)
            }
            set {
                try? keychain.save(value: newValue, forKey: key)
            }
        }
    }

    static internal let userDefaults: UserDefaults = UserDefaults(suiteName: Constants.domain) ?? .standard

    static internal let keychain: Keychain = .init(service: Constants.domain)

    static let storage: Storage = .init()
}

public extension Deboogger.Storage {

    var shouldShowDebooggerButton: Bool {
        get {
            self[defaults: #function] as? Bool ?? false
        }
        set {
            self[defaults: #function] = newValue
        }
    }
}
