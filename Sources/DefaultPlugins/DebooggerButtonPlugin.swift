//
// Copyright (c) 2019 Rosberry. All rights reserved.
//

import Foundation

final class DebooggerButtonPlugin: SwitchPlugin {

    var title: NSAttributedString = .init(string: "Show debug menu button on screen")

    var isOn: Bool {
        Deboogger.shouldShowDebooggerButton
    }

    init() {
        Deboogger.shared.shouldShowAssistiveButton = Deboogger.shouldShowDebooggerButton
    }

    func switchStateChanged(_ sender: UISwitch) {
        Deboogger.shouldShowDebooggerButton = sender.isOn
        Deboogger.shared.shouldShowAssistiveButton = sender.isOn
    }
}
