//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation
import Deboogger

final class ButtonTestPlugin: ButtonPlugin {

    let title: NSAttributedString
    let description: NSAttributedString?

    init(title: NSAttributedString, description: NSAttributedString? = .init(string: "Description for button plugin, Description for button plugin, Description for button plugin, Description for button plugin")) {
        self.title = title
        self.description = description
    }

    func buttonPressed() {
        print("Button pressed")
    }
}
