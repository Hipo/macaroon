// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public struct BannerControllerConfiguration {
    public var contentHorizontalPaddings: LayoutHorizontalPaddings
    /// <note>
    /// It will be used to place the banners from the top edge of the screen, not safe area.
    public var contentTopPadding: LayoutMetric
    public var contentStackSpacing: LayoutMetric
    public var minAutoDissmissDuration: TimeInterval

    public init() {
        self.contentHorizontalPaddings = (16, 16)
        self.contentTopPadding = 32
        self.contentStackSpacing = 8
        self.minAutoDissmissDuration = 2
    }
}
