// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol BorderDrawable: UIView {}

extension BorderDrawable {
    public func drawAppearance(
        border: Border?
    ) {
        guard let border = border else {
            eraseBorder()
            return
        }

        draw(
            border
        )
    }
}

extension BorderDrawable {
    public func draw(
        _ border: Border
    ) {
        layer.draw(
            border
        )
    }

    public func eraseBorder() {
        layer.draw(
            Border(color: .black, width: 0.0)
        )
    }
}

extension CALayer {
    public func draw(
        _ border: Border
    ) {
        borderColor = border.color.cgColor
        borderWidth = border.width
    }
}
