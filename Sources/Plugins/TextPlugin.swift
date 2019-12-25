//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

public protocol TextPlugin: Plugin {
    //
}

public extension TextPlugin {
    var cellClass: BaseTableViewCell.Type {
        return DescriptionTableViewCell.self
    }
}
