// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

open class StorySheetAnimator: ModalAnimator {
    open override func calculatePresentedInitalFrameOnPresenting(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> CGRect {
        let containerBounds = transitionContext.containerView.bounds

        guard let presentedFinalFrame = transitionContext.destinationFinalFrame else {
            return containerBounds
        }

        return CGRect(
            origin: CGPoint(x: presentedFinalFrame.minX, y: presentedFinalFrame.maxY),
            size: presentedFinalFrame.size
        )
    }

    open override func calculatePresentedFinalFrameOnDismissing(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> CGRect {
        let containerBounds = transitionContext.containerView.bounds

        guard let presentedFinalFrame = transitionContext.sourceFinalFrame else {
            return containerBounds
        }

        return CGRect(
            origin: CGPoint(x: presentedFinalFrame.minX, y: presentedFinalFrame.maxY),
            size: presentedFinalFrame.size
        )
    }
}
