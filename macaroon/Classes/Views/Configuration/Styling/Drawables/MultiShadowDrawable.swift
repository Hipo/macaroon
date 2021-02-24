// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol MultiShadowDrawable: UIView {
    var shadowLayers: [CAShapeLayer] { get }

    func drawShadow(_ shadow: Shadow, at index: Int)
    func updateOnLayoutSubviews(_ shadow: Shadow, at index: Int)
    func eraseShadows()
}

extension MultiShadowDrawable {
    public func drawShadow(
        _ shadow: Shadow,
        at index: Int
    ) {
        defer {
            layer.masksToBounds = false

            updateOnLayoutSubviews(
                shadow,
                at: index
            )
        }
    }

    public func updateOnLayoutSubviews(
        _ shadow: Shadow,
        at index: Int
    ) {

    }

    public func eraseShadows() {

    }
}
