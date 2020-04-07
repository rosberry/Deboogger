//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

final class SliderTableViewCell: BaseTableViewCell {

    private enum Constants {
        static let sliderHeight: CGFloat = 40
        static let textFieldHeight: CGFloat = 40
    }

    private var plugin: SliderPlugin?

    // MARK: - Subviews

    private lazy var accessoryContainerView: UIView = .init()

    private lazy var doneButton: UIButton = {
        let view = UIButton()
        view.setTitle("Done", for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        view.backgroundColor = .white
        view.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return view
    }()

    private lazy var sliderView: UISlider = {
        let view = UISlider()
        view.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return view
    }()

    private lazy var textField: UITextField = {
        let view = UITextField()
        view.keyboardType = .decimalPad
        view.borderStyle = .line
        view.placeholder = "Enter manually"
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return view
    }()

    // MARK: - Lifecycle

    override func setup() {
        super.setup()
        accessoryContainerView.addSubview(sliderView)
        accessoryContainerView.addSubview(textField)
        accessoryView = accessoryContainerView
        textField.inputAccessoryView = doneButton
    }

    override func configure(with plugin: Plugin) {
        super.configure(with: plugin)
        self.plugin = plugin as? SliderPlugin

        if let plugin = self.plugin {
            sliderView.minimumValue = plugin.minValue
            sliderView.maximumValue = plugin.maxValue
            sliderView.value = plugin.currentValue
            textField.text = String(plugin.currentValue)
        }

        configureSliderTitle()
    }

    override func layoutSubviews() {
        let containerViewHeight = Constants.sliderHeight + Constants.textFieldHeight
        accessoryContainerView.bounds = CGRect(x: 0.0, y: 0.0, width: bounds.midX, height: containerViewHeight)
        sliderView.frame = CGRect(x: 0.0, y: 0.0, width: bounds.midX, height: Constants.sliderHeight)
        textField.frame = CGRect(x: 0.0, y: sliderView.frame.maxY, width: bounds.midX, height: Constants.textFieldHeight)
        doneButton.sizeToFit()
        super.layoutSubviews()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let bottomInset: CGFloat = 10
        return .init(width: size.width, height: Constants.sliderHeight + Constants.textFieldHeight + bottomInset)
    }

    //MARK: - Actions

    @objc private func sliderValueChanged(_ sender: UISlider) {
        plugin?.currentValue = sender.value
        textField.text = String(sender.value)
        configureSliderTitle()
        plugin?.sliderValueChanged(sender)
    }

    @objc private func textFieldValueChanged(_ sender: UITextField) {
        guard let text = sender.text, let value = Float(text), text.isEmpty == false else {
            return
        }
        plugin?.currentValue = value
        sliderView.setValue(value, animated: true)
    }

    @objc private func doneButtonPressed() {
        endEditing(true)
    }

    // MARK: - Private

    private func configureSliderTitle() {
        detailTextLabel?.attributedText = plugin?.description
        setNeedsLayout()
    }
}

// MARK: - UITextFieldDelegate

extension SliderTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
}
