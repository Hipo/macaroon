// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public struct ToastUIConfiguration {
    public var minContentHorizontalEdgeInsets: NSDirectionalHorizontalEdgeInsets
    /// The start position of the toast view for the presenting animation. The values should be
    /// given by considering the top edge of the screen.
    public var initialPresentingLayoutAttributes: ToastUILayoutAttributes
    /// The end position of the toast view for the presenting animation. The values should be given
    /// by considering the top edge of the safe area of the screen.
    public var finalPresentingLayoutAttributes: ToastUILayoutAttributes
    /// The end position of the toast view for the dismissing animation while another toast view is
    /// being presented. The values should be given by considering the top edge of the safe area of
    /// the screen.
    public var replacingLayoutAttributes: ToastUILayoutAttributes
    /// The end position of the toast view for the dismissing animation. The values should be given
    /// by considering the top edge of the screen.
    public var dismissingLayoutAttributes: ToastUILayoutAttributes

    public var presentingAnimationDuration: TimeInterval
    public var presentingAnimationTimingParameters: UITimingCurveProvider?

    public var replacingAnimationDuration: TimeInterval
    public var replacingAnimationTimingParameters: UITimingCurveProvider?

    public var dismissingAnimationDuration: TimeInterval
    public var dismissingAnimationTimingParameters: UITimingCurveProvider?

    /// The duration to keep the toast on the screen.
    public var presentationDuration: TimeInterval
    
    public init() {
        self.minContentHorizontalEdgeInsets =
            NSDirectionalHorizontalEdgeInsets(leading: 16, trailing: 16)

        var initialPresentingLayoutAttributes = ToastUILayoutAttributes()
        initialPresentingLayoutAttributes.offsetY = 0
        initialPresentingLayoutAttributes.alpha = 0
        self.initialPresentingLayoutAttributes = initialPresentingLayoutAttributes

        var finalPresentingLayoutAttributes = ToastUILayoutAttributes()
        finalPresentingLayoutAttributes.offsetY = 16
        finalPresentingLayoutAttributes.alpha = 1
        self.finalPresentingLayoutAttributes = finalPresentingLayoutAttributes

        var replacingLayoutAttributes = ToastUILayoutAttributes()
        replacingLayoutAttributes.offsetY = 16
        replacingLayoutAttributes.alpha = 0
        self.replacingLayoutAttributes = replacingLayoutAttributes

        var dismissingLayoutAttributes = ToastUILayoutAttributes()
        dismissingLayoutAttributes.offsetY = 0
        dismissingLayoutAttributes.alpha = 0
        self.dismissingLayoutAttributes = dismissingLayoutAttributes

        self.presentingAnimationDuration = 0.2
        self.presentingAnimationTimingParameters = nil

        self.replacingAnimationDuration = 0.2
        self.replacingAnimationTimingParameters = nil

        self.dismissingAnimationDuration = 0.2
        self.dismissingAnimationTimingParameters = nil

        self.presentationDuration = 2
    }
}
