// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

open class AlertUIAnimationController: ModalAnimator {
    private lazy var shadowView = AlertShadowView()

    private let configuration: AlertUIConfiguration

    public init(
        configuration: AlertUIConfiguration
    ) {
        self.configuration = configuration
        super.init(isPresenting: true)
    }

    open override func willAnimatePresenting(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        addShadowToPresentedView(in: transitionContext)
        addCornerToPresentedView(in: transitionContext)

        super.willAnimatePresenting(using: transitionContext)
    }

    open override func animate(
        alongsidePresenting transitionContext: UIViewControllerContextTransitioning
    ) {
        animateShadowOfPresentedView(alongsidePresenting: transitionContext)
        super.animate(alongsidePresenting: transitionContext)
    }

    open override func animate(
        alongsideDismissing transitionContext: UIViewControllerContextTransitioning
    ) {
        animateShadowOfPresentedView(alongsideDismissing: transitionContext)
        super.animate(alongsideDismissing: transitionContext)
    }

    open override func didAnimateDismissing(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        removeShadowFromPresentedView()
        super.didAnimateDismissing(using: transitionContext)
    }

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

extension AlertUIAnimationController {
    private func addShadowToPresentedView(
        in transitionContext: UIViewControllerContextTransitioning
    ) {
        shadowView.drawAppearance(shadow: configuration.contentAreaPrimaryShadow)
        shadowView.drawAppearance(secondShadow: configuration.contentAreaSecondaryShadow)

        let containerView = transitionContext.containerView
        containerView.addSubview(shadowView)

        let initialFrame = calculatePresentedInitalFrameOnPresenting(using: transitionContext)
        shadowView.frame = initialFrame
    }

    private func animateShadowOfPresentedView(
        alongsidePresenting transitionContext: UIViewControllerContextTransitioning
    ) {
        let presentingFrame = transitionContext.destinationFinalFrame ?? .zero
        shadowView.frame = presentingFrame
    }

    private func animateShadowOfPresentedView(
        alongsideDismissing transitionContext: UIViewControllerContextTransitioning
    ) {
        let dismissingFrame = calculatePresentedFinalFrameOnDismissing(using: transitionContext)
        shadowView.frame = dismissingFrame
    }

    private func removeShadowFromPresentedView() {
        shadowView.removeFromSuperview()
    }
}

extension AlertUIAnimationController {
    private func addCornerToPresentedView(
        in transitionContext: UIViewControllerContextTransitioning
    ) {
        let presentedView = transitionContext.destinationView
        presentedView?.layer.draw(corner: configuration.contentAreaCorner)
        presentedView?.layer.masksToBounds = true
    }
}
