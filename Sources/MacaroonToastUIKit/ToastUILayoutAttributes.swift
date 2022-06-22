// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public struct ToastUILayoutAttributes {
    public var offsetY: CGFloat
    public var alpha: CGFloat?
    public var corner: Corner?
    public var zPosition: CGFloat?
    public var transform: CGAffineTransform?

    internal var frame: CGRect?

    public init() {
        self.offsetY = 0
    }
}

extension UIView {
    public func apply(
        _ layoutAttributes: ToastUILayoutAttributes
    ) {
        if let alphaValue = layoutAttributes.alpha {
            layer.opacity = Float(alphaValue)
        }

        if let cornerValue = layoutAttributes.corner {
            layer.draw(corner: cornerValue)
        }

        if let zPositionValue = layoutAttributes.zPosition {
            layer.zPosition = zPositionValue
        }

        /// <note>
        /// Both values can't be applied to the view; otherwise, it will break the layout.
        /// `transform` has higher precedence than `frame` since it can be set explicitly.
        if let transformValue = layoutAttributes.transform {
            layer.setAffineTransform(transformValue)
        } else if let frameValue = layoutAttributes.frame {
            frame = frameValue
        }
    }
}
