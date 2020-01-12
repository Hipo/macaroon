// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension String {
    public func boundingSize(attributes: AttributedTextBuilder.Attribute..., multiline: Bool = true, fittingSize: CGSize = .greatestFiniteMagnitude) -> CGSize {
        let options: NSStringDrawingOptions

        if multiline {
            options = [.usesFontLeading, .usesLineFragmentOrigin, .truncatesLastVisibleLine]
        } else {
            options = [.usesFontLeading]
        }
        let fittingBoundingRect = NSString(string: self).boundingRect(with: fittingSize, options: options, attributes: attributes.convertedToSystemAttributes(), context: nil)
        return CGSize(width: fittingBoundingRect.width.ceil(), height: fittingBoundingRect.height.ceil())
    }
}
