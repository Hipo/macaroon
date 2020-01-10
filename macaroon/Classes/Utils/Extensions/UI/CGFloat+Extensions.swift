// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension CGFloat {
    var isIntrinsicMetric: Bool {
        return self != UIView.noIntrinsicMetric
    }
}
