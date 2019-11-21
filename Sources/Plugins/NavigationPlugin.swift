//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

public protocol NavigationPlugin: TextPlugin {
    //
}

public extension NavigationPlugin {
    var cellClass: BaseTableViewCell.Type {
        return SectionTableViewCell.self
    }
}
