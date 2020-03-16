//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import Foundation

extension Deboogger {

    private enum Constants {
        static let service = "com.rosberry.Deboogger"
    }

    static var keychain: Keychain {
        .init(service: Constants.service)
    }
}
