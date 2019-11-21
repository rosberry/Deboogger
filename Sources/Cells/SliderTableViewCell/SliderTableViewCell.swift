//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit

final class SliderTableViewCell: BaseTableViewCell {
    private var plugin: SliderPlugin?

    private lazy var sliderView: UISlider = {
        let view = UISlider()
        view.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return view
    }()

    // MARK: -

    override func setup() {
        super.setup()
        accessoryView = sliderView
    }

    override func configure(with plugin: Plugin) {
        super.configure(with: plugin)
        self.plugin = plugin as? SliderPlugin

        if let plugin = self.plugin {
            sliderView.minimumValue = plugin.minValue
            sliderView.maximumValue = plugin.maxValue
            sliderView.value = plugin.currentValue
        }

        configureSliderTitle()
    }

    override func layoutSubviews() {
        sliderView.bounds = CGRect(x: 0.0, y: 0.0, width: bounds.midX, height: 40.0)
        super.layoutSubviews()
    }

    //MARK: - Actions

    @objc private func sliderValueChanged(_ sender: UISlider) {
        plugin?.currentValue = sender.value
        configureSliderTitle()
        plugin?.sliderValueChanged(sender)
    }

    private func configureSliderTitle() {
        detailTextLabel?.attributedText = plugin?.description
        setNeedsLayout()
    }
}
