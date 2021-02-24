// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol CornerDrawable: UIView {}

extension CornerDrawable {
    public func drawAppearance(
        corner: Corner?
    ) {
        guard let corner = corner else {
            eraseCorner()
            return
        }

        draw(
            corner
        )
    }
}

extension CornerDrawable {
    public func draw(
        _ corner: Corner
    ) {
        layer.draw(
            corner
        )

        if layer.shadowOpacity == 0 {
            layer.masksToBounds = true
        }
    }

    public func eraseCorner() {
        layer.draw(
            Corner(radius: 0.0)
        )
    }
}

extension CALayer {
    public func draw(
        _ corner: Corner
    ) {
        cornerRadius = corner.radius
        maskedCorners = corner.mask
    }
}
