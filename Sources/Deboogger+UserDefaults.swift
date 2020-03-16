//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2020 Rosberry. All rights reserved.
//

import Foundation

extension Deboogger {

    private enum Constants {
        static let suiteName = "com.rosberry.Deboogger"
    }

    static var userDefaults: UserDefaults {
        UserDefaults(suiteName: Constants.suiteName) ?? .standard
    }
}
