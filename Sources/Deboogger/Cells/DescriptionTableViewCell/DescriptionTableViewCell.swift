//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

final class DescriptionTableViewCell: BaseTableViewCell {

    private var plugin: TextPlugin?
    
    override func configure(with plugin: Plugin) {
        super.configure(with: plugin)
        self.plugin = plugin as? TextPlugin
    }
}
