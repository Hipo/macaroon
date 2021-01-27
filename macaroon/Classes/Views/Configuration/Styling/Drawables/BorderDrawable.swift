// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol BorderDrawable: UIView {
    func draw(_ border: Border)
    func eraseBorder()
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
            Border(
                color: .black,
                width: 0.0
            )
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

extension UIView: BorderDrawable {}
