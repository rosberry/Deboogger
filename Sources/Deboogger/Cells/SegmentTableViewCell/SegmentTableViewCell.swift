//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

final class SegmentTableViewCell: BaseTableViewCell {

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private var plugin: SegmentPlugin?

    // MARK: -

    override func setup() {
        super.setup()
        accessoryView = segmentedControl
    }

    override func configure(with plugin: Plugin) {
        super.configure(with: plugin)
        self.plugin = plugin as? SegmentPlugin

        if let plugin = self.plugin {
            segmentedControl.removeAllSegments()
            plugin.items.enumerated().forEach { offset, item in
                segmentedControl.insertSegment(withTitle: item, at: offset, animated: false)
            }
            segmentedControl.selectedSegmentIndex = Int(plugin.initialSelectedIndex)
            segmentedControl.sizeToFit()
        }
    }

    // MARK: - Actions

    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        plugin?.segmentValueChanged(sender)
    }
}
