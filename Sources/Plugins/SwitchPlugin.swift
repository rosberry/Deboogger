//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

 public protocol SwitchPlugin: TextPlugin {
    var isOn: Bool { get }

    func switchStateChanged(_ sender: UISwitch)
}

public extension SwitchPlugin {
    var cellClass: BaseTableViewCell.Type {
        return SwitchTableViewCell.self
    }
}
