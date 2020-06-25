// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UIView {
    public func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

extension Array where Element: UIView {
    public mutating func removeFromSuperview() {
        forEach { $0.removeFromSuperview() }
        removeAll()
    }
}
