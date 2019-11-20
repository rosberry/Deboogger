//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        accessoryType = .disclosureIndicator
    }

    func configure(with section: Section) {
        textLabel?.text = section.title
    }
}
