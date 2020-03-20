// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public class Label: UILabel {
    open var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let textRect = super.textRect(forBounds: bounds.inset(by: contentEdgeInsets), limitedToNumberOfLines: numberOfLines)
        return textRect.inset(by: contentEdgeInsets.inverted())
    }

    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentEdgeInsets))
    }
}
