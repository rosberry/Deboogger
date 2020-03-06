//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import Foundation
import Deboogger

final class SegmentTestPlugin: SegmentPlugin {

    var items: [String] {
        return ["First", "2", "Third"]
    }

    let title: NSAttributedString
    let description: NSAttributedString?

    var initialSelectedIndex: Int {
        return 0
    }

    init(title: NSAttributedString, description: NSAttributedString? = .init(string: "Description for segment plugin which is long enough to be multi-line")) {
        self.title = title
        self.description = description
    }

    func segmentValueChanged(_ sender: UISegmentedControl) {
        print("Segment selected: \(sender.selectedSegmentIndex)")
    }
}
