//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

final class SwitchTableViewCell: BaseTableViewCell {

    private var plugin: SwitchPlugin?

    private lazy var switchView: UISwitch = {
        let view = UISwitch()
        view.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return view
    }()

    // MARK: -

    override func setup() {
        super.setup()
        accessoryView = switchView
    }

    override func configure(with plugin: Plugin) {
        super.configure(with: plugin)

        self.plugin = plugin as? SwitchPlugin
        switchView.isOn = self.plugin?.isOn == true
    }

    // MARK: - Actions

    @objc func switchValueChanged() {
        plugin?.switchStateChanged(switchView)
    }
}
