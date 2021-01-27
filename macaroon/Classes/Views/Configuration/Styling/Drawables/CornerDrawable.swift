// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol CornerDrawable: UIView {
    func draw(_ corner: Corner)
    func eraseCorner()
}

extension CornerDrawable {
    public func draw(
        _ corner: Corner
    ) {
        layer.draw(
            corner
        )

        if !(self is ShadowDrawable) {
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

extension UIView: CornerDrawable {}
