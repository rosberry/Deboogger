//
// Copyright (c) 2019 Rosberry. All rights reserved.
//

import Foundation

final class DebooggerButtonPlugin: SwitchPlugin {

    private var shouldShowDebooggerButton: Bool {
        get {
            if let shouldShow = UserDefaults.standard.object(forKey: "deboogger_\(#function)") as? Bool {
                return shouldShow
            }

            var shouldShow = false
            #if targetEnvironment(simulator)
                shouldShow = true
            #endif
            UserDefaults.standard.set(shouldShow, forKey: "deboogger_\(#function)")
            return shouldShow
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "deboogger_\(#function)")
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
