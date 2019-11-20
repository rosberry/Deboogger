//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit

public protocol ButtonPlugin: TextPlugin {
    func buttonPressed(_ sender: UIButton)
}

public extension ButtonPlugin {
    var cellClass: BaseTableViewCell.Type {
        return ButtonTableViewCell.self
    }
}
