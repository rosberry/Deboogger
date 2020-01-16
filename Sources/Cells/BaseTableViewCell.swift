//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

public class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        selectionStyle = .none

        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
    }
    
    public func configure(with plugin: Plugin) {
        textLabel?.attributedText = plugin.title
        detailTextLabel?.attributedText = plugin.description
    }
}
