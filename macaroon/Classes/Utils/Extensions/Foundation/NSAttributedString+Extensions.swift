// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension NSAttributedString {
    public func boundingSize(multiline: Bool = true, fittingSize: CGSize = .greatestFiniteMagnitude) -> CGSize {
        let options: NSStringDrawingOptions

        if multiline {
            options = [.usesFontLeading, .usesLineFragmentOrigin, .truncatesLastVisibleLine]
        } else {
            options = [.usesFontLeading]
        }
        let fittingBoundingRect = boundingRect(with: fittingSize, options: options, context: nil)
        return CGSize(width: fittingBoundingRect.width.ceil(), height: fittingBoundingRect.height.ceil())
    }
}
