//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation
import Deboogger

final class ButtonTestPlugin: ButtonPlugin {

    var title: NSAttributedString {
        return NSAttributedString(string: "Title for button plugin")
    }

    var description: NSAttributedString? {
        return NSAttributedString(string: "Description for segment plugin, Description for segment plugin, Description for segment plugin, Description for segment plugin")
    }

    func buttonPressed(_ sender: UIButton?) {
        print("Button pressed")
    }
}
