//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit

public protocol TextFieldPlugin: Plugin {

    var placeholder: String { get }
    var keyboardType: UIKeyboardType { get }
    var initialValue: String? { get }

    func textFieldValueChanged(_ textField: UITextField)
}

public extension TextFieldPlugin {
    var cellClass: BaseTableViewCell.Type {
        return TextFieldTableViewCell.self
    }

    var placeholder: String {
        "Enter text"
    }

    var keyboardType: UIKeyboardType {
        .default
    }

    var initialValue: String? {
        nil
    }
}
