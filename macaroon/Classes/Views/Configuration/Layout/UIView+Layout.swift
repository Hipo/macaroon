// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

extension UIView {
    public var compactSafeAreaInsets: UIEdgeInsets {
        if let window = window {
            return window.safeAreaInsets
        }
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
}
