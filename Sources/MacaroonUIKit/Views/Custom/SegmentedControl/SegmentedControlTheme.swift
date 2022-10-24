// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol SegmentedControlTheme:
    StyleSheet,
    LayoutSheet {
    var background: ImageStyle? { get }
    var divider: ImageStyle? { get }
    var spacingBetweenSegments: CGFloat { get }
}

extension SegmentedControlTheme {
    var spacingBetweenSegmentAndDivider: CGFloat {
        return spacingBetweenSegments / 2
    }
}
