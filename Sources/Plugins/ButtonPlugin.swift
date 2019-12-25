//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

public protocol ButtonPlugin: TextPlugin {
    func buttonPressed()
}

public extension ButtonPlugin {
    var cellClass: BaseTableViewCell.Type {
        return ButtonTableViewCell.self
    }

    func selectionAction() {
        buttonPressed()
    }
}
