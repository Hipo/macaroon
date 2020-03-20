// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UIEdgeInsets {
    public var x: CGFloat {
        return left + right
    }
    public var y: CGFloat {
        return top + bottom
    }
}

extension UIEdgeInsets {
    public func inverted() -> UIEdgeInsets {
        return multiplied(-1)
    }

    public func multiplied(_ multiplier: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top * multiplier, left: left * multiplier, bottom: bottom * multiplier, right: right * multiplier)
    }
}
