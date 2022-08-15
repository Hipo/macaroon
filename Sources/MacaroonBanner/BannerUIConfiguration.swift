// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public struct BannerUIConfiguration {
    public var contentHorizontalEdgeInsets: LayoutHorizontalMargins
    /// It will be used to place the banners from the top edge of the screen, not safe area.
    public var contentTopPadding: LayoutMetric
    public var contentStackSpacing: LayoutMetric

    public var presentingAnimationDuration: TimeInterval
    public var presentingAnimationTimingParameters: UITimingCurveProvider?

    public var dismissingAnimationDuration: TimeInterval
    public var dismissingAnimationTimingParameters: UITimingCurveProvider?

    /// The duration to keep the banner on the screen.
    public var presentationDuration: TimeInterval

    public init() {
        self.contentHorizontalEdgeInsets = (16, 16)
        self.contentTopPadding = 32
        self.contentStackSpacing = 8

        self.presentingAnimationDuration = 0.1
        self.presentingAnimationTimingParameters = nil

        self.dismissingAnimationDuration = 0.1
        self.dismissingAnimationTimingParameters = nil

        self.presentationDuration = 2
    }
}
