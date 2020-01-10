// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UIEdgeInsets {
    var x: CGFloat {
        return left + right
    }
    var y: CGFloat {
        return top + bottom
    }
}
