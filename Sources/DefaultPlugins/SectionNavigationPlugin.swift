//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import Foundation

final class SectionNavigationPlugin: NavigationPlugin {
    let title: NSAttributedString
    let action: () -> Void

    init(title: String, action: @escaping () -> Void) {
        self.title = NSAttributedString(string: title)
        self.action = action
    }

    func selectionAction() {
        action()
    }
}
