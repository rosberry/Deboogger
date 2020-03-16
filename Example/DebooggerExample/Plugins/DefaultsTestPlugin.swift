//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import Foundation
import Deboogger

final class DefaultsTestPlugin: SwitchPlugin {

    private enum Constants {
        static let key = "key"
    }

    let title: NSAttributedString = .init(string: "Saving to UserDefaults")
    let description: NSAttributedString = .init(string: "Save value to Deboogger's defaults")

    var isOn: Bool {
        Deboogger.storage[defaults: Constants.key] as? Bool ?? false
    }

    func switchStateChanged(_ sender: UISwitch) {
        Deboogger.storage[defaults: Constants.key] = sender.isOn
    }
}
