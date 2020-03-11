//
// Copyright (c) 2019 Rosberry. All rights reserved.
//

import Foundation

final class DebooggerButtonPlugin: SwitchPlugin {

    var title: NSAttributedString = .init(string: "Show debug menu button on screen")

    var isOn: Bool {
        UserDefaults.deboogger.shouldShowDebooggerButton
    }

    init() {
        Deboogger.shared.shouldShowAssistiveButton = UserDefaults.deboogger.shouldShowDebooggerButton
    }

    func switchStateChanged(_ sender: UISwitch) {
        UserDefaults.deboogger.shouldShowDebooggerButton = sender.isOn
        Deboogger.shared.shouldShowAssistiveButton = sender.isOn
    }
}

extension UserDefaults {

    var shouldShowDebooggerButton: Bool {
        get {
            bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
