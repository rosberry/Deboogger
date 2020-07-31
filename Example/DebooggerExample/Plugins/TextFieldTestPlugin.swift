//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import Deboogger

final class TextFieldTestPlugin: TextFieldPlugin {
    var placeholder: String = "test"
    var title: NSAttributedString = .init(string: "TextFieldPlugin") 

    func textFieldValueChanged(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        print(#function, text)
    }

}
