//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

 public protocol SegmentPlugin: TextPlugin {
     var items: [String] { get }
     var initialSelectedIndex: Int { get }
    
     func segmentValueChanged(_ sender: UISegmentedControl)
}

public extension SegmentPlugin {

    var cellClass: BaseTableViewCell.Type {
        return SegmentTableViewCell.self
    }
}
