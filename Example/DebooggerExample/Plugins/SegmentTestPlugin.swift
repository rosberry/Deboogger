//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation
import Deboogger

final class SegmentTestPlugin: SegmentPlugin {

    var items: [String] {
        return ["First", "2", "Third"]
    }

    var title: NSAttributedString {
        return NSAttributedString(string: "Title for segment plugin")
    }

    var description: NSAttributedString? {
        return NSAttributedString(string: "Description for segment plugin which is long enough to be multi-line")
    }

    var initialSelectedIndex: Int {
        return 0
    }

    func segmentValueChanged(_ sender: UISegmentedControl) {
        print("Segment selected: \(sender.selectedSegmentIndex)")
    }
}
