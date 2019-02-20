//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit

 public protocol SwitchPlugin: TextPlugin {

    var isOn: Bool { get }
    func switchStateChanged(_ sender: UISwitch)
}

public extension SwitchPlugin {

    private typealias Cell = SwitchTableViewCell
    
    var nib: UINib {
        return UINib(nibName: cellIdentifier, bundle: Bundle.deboogger)
    }
    
    var cellIdentifier: String {
        return String(describing: Cell.self)
    }
    
    func configure(_ cell: UITableViewCell) {
        (cell as? Cell)?.configure(by: self)
    }
}
