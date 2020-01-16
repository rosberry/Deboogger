//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

class SectionTableViewCell: BaseTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        selectionStyle = .default
        accessoryType = .disclosureIndicator
    }
}
