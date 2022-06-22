// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import UIKit

open class ToastUIAnimationController: ToastUIAnimationControlling {
    private var config: ToastUIConfiguration

    private unowned let presentingView: UIView

    private let layoutCalculator: ToastUILayoutCalculating

    public init(
        config: ToastUIConfiguration,
        presentingView: UIView,
        layoutCalculator: ToastUILayoutCalculating
    ) {
        self.config = config
        self.presentingView = presentingView
        self.layoutCalculator = layoutCalculator
    }

    open func prepareForAnimation(
        presented viewToPresent: UIView
    ) {
        applyInitialPresentingLayoutAttributes(toNextPresented: viewToPresent)
    }

    open func makePresentingAnimator(
        forNextPresented nextView: UIView
    ) -> UIViewPropertyAnimator {
        let animator = makeAnimator(
            duration: config.presentingAnimationDuration,
            timingParameters: config.presentingAnimationTimingParameters
        )
        animator.isInterruptible = false
        animator.addAnimations {
            [unowned self] in
            self.performPresentingAnimations(forNextPresented: nextView)
        }
        return animator
    }

    open func performPresentingAnimations(
        forNextPresented nextView: UIView
    ) {
        applyFinalPresentingLayoutAttributes(toNextPresented: nextView)
    }

    open func makePresentingAnimator(
        forNextPresented nextView: UIView,
        replacingLastPresented lastView: UIView
    ) -> UIViewPropertyAnimator {
        let animator = makeAnimator(
            duration: config.replacingAnimationDuration,
            timingParameters: config.replacingAnimationTimingParameters
        )
        animator.isInterruptible = false
        animator.addAnimations {
            [unowned self] in
            self.performPresentingAnimations(
                forNextPresented: nextView,
                replacingLastPresented: lastView
            )
        }
        animator.addCompletion {
            _ in
            lastView.removeFromSuperview()
        }
        return animator
    }

    open func performPresentingAnimations(
        forNextPresented nextView: UIView,
        replacingLastPresented lastView: UIView
    ) {
        applyReplacingLayoutAttributes(toLastPresented: lastView)
        applyFinalPresentingLayoutAttributes(toNextPresented: nextView)
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
            [unowned self] in
            self.performDismissingAnimations(forLastPresented: lastView)
        }
        animator.addCompletion {
            _ in
            lastView.removeFromSuperview()
        }
        return animator
    }

    open func performDismissingAnimations(
        forLastPresented lastView: UIView
    ) {
        applyDismissingLayoutAttributes(toLastPresented: lastView)
    }

    open func makeAnimator(
        duration: TimeInterval,
        timingParameters: UITimingCurveProvider? = nil
    ) -> UIViewPropertyAnimator {
        let animator: UIViewPropertyAnimator

        if let timingParameters = timingParameters {
            animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        } else {
            animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut)
        }

        return animator
    }
}

extension ToastUIAnimationController {
    public func applyInitialPresentingLayoutAttributes(
        toNextPresented nextView: UIView
    ) {
        var layoutAttributes = config.initialPresentingLayoutAttributes
        layoutAttributes.frame = layoutCalculator.calculateInitialFrame(ofNextPresented: nextView)
        nextView.apply(layoutAttributes)
    }

    public func applyFinalPresentingLayoutAttributes(
        toNextPresented nextView: UIView
    ) {
        var layoutAttributes = config.finalPresentingLayoutAttributes
        layoutAttributes.frame = layoutCalculator.calculateFinalFrame(ofNextPresented: nextView)
        nextView.apply(layoutAttributes)
    }

    public func applyReplacingLayoutAttributes(
        toLastPresented lastView: UIView
    ) {
        var layoutAttributes = config.replacingLayoutAttributes
        layoutAttributes.frame = layoutCalculator.calculateFinalFrame(
            ofReplacingLastPresented: lastView
        )
        lastView.apply(layoutAttributes)
    }

    public func applyDismissingLayoutAttributes(
        toLastPresented lastView: UIView
    ) {
        var layoutAttributes = config.dismissingLayoutAttributes
        layoutAttributes.frame = layoutCalculator.calculateFinalFrame(
            ofDismissingLastPresented: lastView
        )
        lastView.apply(layoutAttributes)
    }
}
