//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import Foundation

final class Keychain {

    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
        case wrongEncoding
    }

    let service: String

    init(service: String) {
        self.service = service
    }

    func readPassword(forKey key: String) throws -> String {
        var query = makeKeychainQuery(account: key)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) { pointer in
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(pointer))
        }

        guard status != errSecItemNotFound else {
            throw KeychainError.noPassword
        }
        guard status == noErr else {
            throw KeychainError.unhandledError(status: status)
        }
        guard let existingItem = queryResult as? [String: AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }

        return password
    }

    func save(value: String?, forKey key: String) throws {
        guard let value = value else {
            let query = makeKeychainQuery(account: key)
            let status = SecItemDelete(query as CFDictionary)
            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)
            }
            return
        }
        guard let encodedPassword = value.data(using: .utf8) else {
            throw KeychainError.wrongEncoding
        }

        do {
            try _ = readPassword(forKey: key)

            var updateAttributes = [String: AnyObject]()
            updateAttributes[kSecValueData as String] = encodedPassword as AnyObject?

            let query = makeKeychainQuery(account: key)
            let status = SecItemUpdate(query as CFDictionary, updateAttributes as CFDictionary)

            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)
            }
        }
        catch KeychainError.noPassword {
            var newItem = makeKeychainQuery(account: key)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?

            let status = SecItemAdd(newItem as CFDictionary, nil)

            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)
            }
        }
    }

    // MARK: - Private

    private func makeKeychainQuery(account: String) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        query[kSecAttrAccount as String] = account as AnyObject?
        return query
    }
}
