//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation
import Deboogger

struct SwitchTestPlugin: SwitchPlugin {
    
    let title: NSAttributedString
    let description: NSAttributedString?
    
    var isOn: Bool {
        return true
    }

    init(title: NSAttributedString, description: NSAttributedString? = .init(string: "Description Description Description Description Description Description Description Description Description Description ")) {
        self.title = title
        self.description = description
    }
    
    func switchStateChanged(_ sender: UISwitch) {
        print("Switch: \(sender.isOn ? "on" : "off")")
    }
}
