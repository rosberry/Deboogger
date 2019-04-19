//
// Copyright (c) 2019 Rosberry. All rights reserved.
//

import Foundation

final class DebooggerButtonPlugin: SwitchPlugin {

    private enum Constants {
        static let debooggerPrefix: String = "deboogger_"
    }

    private var shouldShowDebooggerButton: Bool {
        get {
            if let shouldShow = UserDefaults.standard.object(forKey: Constants.debooggerPrefix + "\(#function)") as? Bool {
                return shouldShow
            }

            let shouldShow = Deboogger.shared.shouldShowAssistiveButton
            UserDefaults.standard.set(shouldShow, forKey: Constants.debooggerPrefix + "\(#function)")
            return shouldShow
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.debooggerPrefix + "\(#function)")
        }
    }

    init() {
        Deboogger.shared.shouldShowAssistiveButton = shouldShowDebooggerButton
    }

    var title: NSAttributedString = .init(string: "Show debug menu button on screen")
    var isOn: Bool {
        return shouldShowDebooggerButton
    }

    func switchStateChanged(_ sender: UISwitch) {
        shouldShowDebooggerButton = sender.isOn
        Deboogger.shared.shouldShowAssistiveButton = shouldShowDebooggerButton
    }
}
