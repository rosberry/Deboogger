//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit

final class ButtonTableViewCell: BaseTableViewCell {
    private var plugin: ButtonPlugin?
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.isUserInteractionEnabled = false
        button.setTitle("🚀", for: .normal)
        button.sizeToFit()
        return button
    }()

    override func setup() {
        super.setup()

        selectionStyle = .default
        accessoryView = button
    }
    
    override func configure(with plugin: Plugin) {
        super.configure(with: plugin)
        self.plugin = plugin as? ButtonPlugin
    }
}
