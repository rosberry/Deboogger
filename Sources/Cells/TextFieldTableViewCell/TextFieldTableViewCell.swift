//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

final class TextFieldTableViewCell: BaseTableViewCell {

    private lazy var textField: UITextField = {
        let view = UITextField()
        view.keyboardType = .decimalPad
        view.borderStyle = .line
        view.placeholder = "Enter manually"
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return view
    }()


    @objc private func textFieldValueChanged(_ sender: UITextField) {

    }
}

// MARK: - UITextFieldDelegate

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
}
