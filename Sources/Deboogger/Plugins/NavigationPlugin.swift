//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

public enum NavigationStyle {
    case plain
    case nested
}

public protocol NavigationPlugin: TextPlugin {
    var plugins: [Plugin] { get }
    var style: NavigationStyle { get }
}

public extension NavigationPlugin {
    var cellClass: BaseTableViewCell.Type {
        return SectionTableViewCell.self
    }
}
