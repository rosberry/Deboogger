//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

final class PaddingLabel: UILabel {

    var textPaddings: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += textPaddings.left + textPaddings.right
        size.height += textPaddings.top + textPaddings.bottom
        return size
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.width += textPaddings.left + textPaddings.right
        sizeThatFits.height += textPaddings.top + textPaddings.bottom
        return sizeThatFits
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textPaddings))
    }
}
