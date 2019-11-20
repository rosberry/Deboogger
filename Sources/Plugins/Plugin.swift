//
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit

 public protocol Plugin {
    var cellClass: BaseTableViewCell.Type { get }

    var title: NSAttributedString { get }
    var description: NSAttributedString? { get }
    var keywords: String { get }

    func configure(_ cell: BaseTableViewCell)
    func selectionAction()
}

public extension Plugin {

    var description: NSAttributedString? {
        return nil
    }

    var keywords: String {
        return title.string + (description?.string ?? "")
    }

    private func cast<T>(value: Any, to type: T) -> T? {
        return value as? T
    }

    func configure(_ cell: BaseTableViewCell) {
        cast(value: cell, to: cellClass.self)?.configure(cell)(with: self)
    }

    func selectionAction() {
        //
    }
}
