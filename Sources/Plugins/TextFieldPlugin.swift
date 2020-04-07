//
//  Copyright © 2019 Rosberry. All rights reserved.
//

public protocol TextFieldPlugin: Plugin {

}

extension TextFieldPlugin {
    var cellClass: BaseTableViewCell.Type {
        return DescriptionTableViewCell.self
    }
}
