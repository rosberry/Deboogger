//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
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

    override func setup() {
        super.setup()

        contentView.addSubview(segmentedControl)

        if let label = textLabel {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0).isActive = true
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0).isActive = true
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0).isActive = true
        }

        if let label = detailTextLabel {
            label.translatesAutoresizingMaskIntoConstraints = false
            if let textLabel = textLabel {
                label.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 4.0).isActive = true
            }
            else {
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0).isActive = true
            }
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0).isActive = true
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0).isActive = true
        }

        segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0).isActive = true
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {

        var size = super.systemLayoutSizeFitting(targetSize,
                                                 withHorizontalFittingPriority: horizontalFittingPriority,
                                                 verticalFittingPriority: verticalFittingPriority)
        size.height += segmentedControl.bounds.height + 8.0
        return size

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
