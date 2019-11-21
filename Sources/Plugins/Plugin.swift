//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

 public protocol Plugin {
    var cellClass: BaseTableViewCell.Type { get }

    var title: NSAttributedString { get }
    var description: NSAttributedString? { get }
    var keywords: String { get }

    func selectionAction()
}

public extension Plugin {

    var description: NSAttributedString? {
        return nil
    }

    var keywords: String {
        return title.string + (description?.string ?? "")
    }

    func selectionAction() {
        //
    }
}
