//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

final class TextFieldTableViewCell: BaseTableViewCell {

    private var plugin: TextFieldPlugin?

    private lazy var textField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return view
    }()

    override func setup() {
        super.setup()
        accessoryView = textField
    }

    override func configure(with plugin: Plugin) {
        super.configure(with: plugin)
        self.plugin = plugin as? TextFieldPlugin

        if let plugin = self.plugin {
            textField.placeholder = plugin.placeholder
            textField.text = plugin.initialValue
            textField.keyboardType = plugin.keyboardType
        }
    }

    override func layoutSubviews() {
        textField.bounds = CGRect(origin: .zero, size: .init(width: contentView.bounds.midX, height: 40))
        super.layoutSubviews()
    }

    @objc private func textFieldValueChanged(_ sender: UITextField) {
        plugin?.textFieldValueChanged(sender)
    }
}

// MARK: - UITextFieldDelegate

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
}
