// Copyright © Hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

extension String {
    public func boundingSize(attributes: AttributedTextBuilder.Attribute..., multiline: Bool = true, fittingSize: CGSize = .greatestFiniteMagnitude) -> CGSize {
        let options: NSStringDrawingOptions

        if multiline {
            options = [.usesFontLeading, .usesLineFragmentOrigin, .truncatesLastVisibleLine]
        } else {
            options = [.usesFontLeading]
        }
        let fittingBoundingRect = NSString(string: self).boundingRect(with: fittingSize, options: options, attributes: attributes.asSystemAttributes(), context: nil)
        return fittingBoundingRect.size
    }
}

extension NSAttributedString {
    public func boundingSize(multiline: Bool = true, fittingSize: CGSize = .greatestFiniteMagnitude) -> CGSize {
        let options: NSStringDrawingOptions

        if multiline {
            options = [.usesLineFragmentOrigin, .truncatesLastVisibleLine]
        } else {
            options = []
        }
        let fittingBoundingRect = boundingRect(with: fittingSize, options: options, context: nil)
        return fittingBoundingRect.size
    }
}
