// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import UIKit

open class BannerUIAnimationController: BannerUIAnimationControlling {
    private var config: BannerUIConfiguration

    private unowned let presentingView: UIView

    public init(
        config: BannerUIConfiguration,
        presentingView: UIView
    ) {
        self.config = config
        self.presentingView = presentingView
    }

    open func makePresentingAnimator(
        forNextPresented nextView: UIView
    ) -> UIViewPropertyAnimator {
        nextView.isHidden = true
        let animator = makeAnimator(
            duration: config.presentingAnimationDuration,
            timingParameters: config.presentingAnimationTimingParameters
        )
        animator.isInterruptible = false
        animator.addAnimations {
            nextView.isHidden = false
        }
        return animator
    }

    open func makeDismissingAnimator(
        forLastPresented lastView: UIView
    ) -> UIViewPropertyAnimator {
        let animator = makeAnimator(
            duration: config.dismissingAnimationDuration,
            timingParameters: config.dismissingAnimationTimingParameters
        )
        animator.isInterruptible = true
        animator.addAnimations {
            lastView.isHidden = true
        }
        return animator
    }

    open func makeAnimator(
        duration: TimeInterval,
        timingParameters: UITimingCurveProvider? = nil
    ) -> UIViewPropertyAnimator {
        let animator: UIViewPropertyAnimator

        if let timingParameters = timingParameters {
            animator = UIViewPropertyAnimator(
                duration: duration,
                timingParameters: timingParameters
            )
        } else {
            animator = UIViewPropertyAnimator(
                duration: duration,
                curve: .easeOut
            )
        }

        return animator
    }
}
