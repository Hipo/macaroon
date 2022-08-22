// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

open class BottomSheetPresentationController:
    ModalPresentationController<BottomSheetPresentationConfiguration>,
    UIGestureRecognizerDelegate {
    public private(set) lazy var overlayView = BottomSheetOverlayView()

    public var presentedContentViewController: UIViewController {
        let navigationController = presentedViewController as? UINavigationController
        return navigationController?.viewControllers.last ?? presentedViewController
    }
    public var presentedContentView: UIView {
        return presentedContentViewController.view
    }
    public var presentedScrollView: UIScrollView? {
        let contentConfigurableViewController = presentedContentViewController as? BottomSheetScrollPresentable
        return contentConfigurableViewController?.scrollView
    }
    public var modalHeight: ModalHeight {
        return (presentedContentViewController as? ModalCustomPresentable)?.modalHeight ?? .compressed
    }
    public var modalBottomPadding: LayoutMetric {
        return (presentedContentViewController as? BottomSheetPresentable)?.modalBottomPadding ?? 0
    }

    private var cachedContentAreaHeight: CGFloat?

    private var safeAreaInsets: UIEdgeInsets {
        return containerView?.safeAreaInsets ?? .zero
    }

    public let interactor: BottomSheetInteractor?

    public init(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?,
        interactor: BottomSheetInteractor?,
        configuration: BottomSheetPresentationConfiguration = BottomSheetPresentationConfiguration()
    ) {
        self.interactor = interactor

        super.init(
            presentedViewController: presentedViewController,
            presentingViewController: presentingViewController,
            configuration: configuration
        )
    }

    open override func calculateOriginOfPresentedView(
        withSize size: LayoutSize,
        inParentWithSize parentSize: LayoutSize
    ) -> LayoutOffset {
        return (0, parentSize.h - size.h - modalBottomPadding)
    }

    open override func calculateSizeOfPresentedView(
        inParentWithSize parentSize: LayoutSize
    ) -> LayoutSize {
        let targetWidth = parentSize.w

        let preferredHeight: CGFloat
        switch modalHeight {
        case .compressed:
            let navigationAreaHeight = calculateNavigationAreaHeight()
            let contentAreaHeight = calculateContentAreaCompressedHeightFitting(targetWidth)
            let safeAreaHeight = modalBottomPadding > 0 ? 0 : safeAreaInsets.bottom
            preferredHeight =
                navigationAreaHeight +
                contentAreaHeight +
                safeAreaHeight

            cachedContentAreaHeight = contentAreaHeight
        case .expanded:
            let navigationAreaHeight = calculateNavigationAreaHeight()
            let contentAreaHeight = calculateContentAreaExpandedHeightFitting(targetWidth)
            let safeAreaHeight = modalBottomPadding > 0 ? 0 : safeAreaInsets.bottom
            preferredHeight =
                navigationAreaHeight +
                contentAreaHeight +
                safeAreaHeight

            cachedContentAreaHeight = contentAreaHeight
        case .proportional(let proportion):
            let contentAreaHeight = parentSize.h * proportion
            preferredHeight = contentAreaHeight

            cachedContentAreaHeight = contentAreaHeight
        case .preferred(let height):
            let contentAreaHeight = height
            /// <note>
            /// Return a height without the safe area inset.
            if modalBottomPadding == 0 {
                let safeAreaHeight = safeAreaInsets.bottom
                preferredHeight = contentAreaHeight + safeAreaHeight
            } else {
                /// <note>
                /// Return safe area inset with `modalBottomPadding`.
                preferredHeight = contentAreaHeight
            }

            cachedContentAreaHeight = contentAreaHeight
        }

        let size = CGSize(width: parentSize.w, height: parentSize.h)
        let maxHeight = calculateMaxPresentedAreaHeight(inParentWithSize: size)
        let targetHeight = max(0, min(preferredHeight, maxHeight))

        return (targetWidth, targetHeight.ceil())
    }

    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        overlayView.frame = calculateFinalFrameOfOverlayView()
    }

    open override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        setScrollEnabledIfNeeded()
    }

    open override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        addOverlay()
        prepareForInteractiveUse()
    }

    open override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        removeOverlay()
    }

    /// <mark>
    /// UIGestureRecognizerDelegate
    open func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return presentedScrollView?.isScrollOnTop ?? true
    }
}

extension BottomSheetPresentationController {
    private func setScrollEnabledIfNeeded() {
        presentedScrollView?.isScrollEnabled = presentedScrollView?.isScrollable ?? true
    }
}

extension BottomSheetPresentationController {
    private func calculateMaxPresentedAreaHeight(
        inParentWithSize parentSize: CGSize
    ) -> CGFloat {
        let preferredMaxHeight =
            parentSize.height -
            modalBottomPadding -
            safeAreaInsets.top
        let thresholdMaxHeight = parentSize.height * 0.93
        return min(preferredMaxHeight, thresholdMaxHeight)
    }

    private func calculateNavigationAreaHeight() -> CGFloat {
        let navigationController = presentedViewController as? UINavigationController
        return navigationController?.navigationBarHeight ?? 0
    }

    private func calculateContentAreaCompressedHeightFitting(
        _ targetWidth: CGFloat
    ) -> CGFloat {
        var targetSize = UIView.layoutFittingCompressedSize
        targetSize.width = targetWidth
        return calculateContentAreaHeightFitting(targetSize)
    }

    private func calculateContentAreaExpandedHeightFitting(
        _ targetWidth: CGFloat
    ) -> CGFloat {
        var targetSize = UIView.layoutFittingExpandedSize
        targetSize.width = targetWidth
        return calculateContentAreaHeightFitting(targetSize)
    }

    private func calculateContentAreaHeightFitting(
        _ targetSize: CGSize
    ) -> CGFloat {
        if let cachedContentAreaHeight = cachedContentAreaHeight.unwrapNonZeroDouble() {
            return cachedContentAreaHeight
        }

        /// <note>
        /// Use the visible view controller to calculate the height because a navigation controller
        /// gives us a zero.

        if let customPresentedContentViewController = presentedContentViewController as? BottomSheetPresentable {
            return customPresentedContentViewController.calculateContentAreaHeightFitting(targetSize)
        }

        let contentView = presentedContentViewController.view
        let newContentAreaSize = contentView?.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        return newContentAreaSize?.height ?? 0
    }
}

extension BottomSheetPresentationController {
    private func prepareForInteractiveUse() {
        guard let interactor = interactor else {
            return
        }
        
        interactor.animate(
            alongsideTransition: {
                [unowned self] progress in

                self.chromeView.alpha = 1 - progress

                self.updateOverlayLayoutOnDragging(
                    progress: progress
                )
            },
            completion: nil
        )

        presentedView?.addGestureRecognizer(
            interactor.createInteractiveGestureRecognizer()
        )
        overlayView.addGestureRecognizer(
            interactor.createInteractiveGestureRecognizer()
        )

        guard let presentedScrollView = presentedScrollView else {
            return
        }

        let scrollInteractiveGestureRecognizer =
            interactor.createInteractiveScrollingGestureRecognizer()
        scrollInteractiveGestureRecognizer.delegate = self

        presentedScrollView.addGestureRecognizer(
            scrollInteractiveGestureRecognizer
        )
        presentedScrollView.panGestureRecognizer.require(
            toFail: scrollInteractiveGestureRecognizer
        )
    }
}

extension BottomSheetPresentationController {
    private func addOverlay() {
        guard let containerView = containerView else {
            return
        }

        containerView.addSubview(
            overlayView
        )
        overlayView.customizeAppearance(
            configuration.overlayStyleSheet
        )
        overlayView.prepareLayout(
            configuration.overlayLayoutSheet
        )

        overlayView.frame =
            CGRect(
                x: 0,
                y: containerView.bounds.height - configuration.overlayOffset,
                width: containerView.bounds.width,
                height: containerView.bounds.height
            )

        let finalFrame = calculateFinalFrameOfOverlayView()

        guard let transitionCoordinator = presentedViewController.transitionCoordinator else {
            overlayView.frame = finalFrame
            return
        }

        transitionCoordinator.animate(
            alongsideTransition: {
                [unowned self] _ in

                self.overlayView.frame = finalFrame
            },
            completion: nil
        )
    }

    private func updateOverlayLayoutOnDragging(
        progress: CGFloat
    ) {
        guard
            let containerView = containerView,
            let presentedView = presentedView
        else {
            return
        }

        let presentedMinY = presentedView.frame.minY

        var draggingFrame = overlayView.frame
        draggingFrame.origin.y = presentedMinY - configuration.overlayOffset
        overlayView.frame = draggingFrame

        if presentedMinY >= containerView.bounds.height {
            overlayView.resetShadowAppearance()
        }
    }

    private func removeOverlay() {
        if let interactor = interactor,
           interactor.inProgress {
            return
        }

        var finalFrame = overlayView.frame
        finalFrame.origin.y = presentationBounds.height - configuration.overlayOffset

        guard let transitionCoordinator = presentedViewController.transitionCoordinator else {
            overlayView.frame = finalFrame
            return
        }

        transitionCoordinator.animate(
            alongsideTransition: {
                [unowned self] _ in

                self.overlayView.frame = finalFrame
            },
            completion: nil
        )
    }
}

extension BottomSheetPresentationController {
    private func calculateFinalFrameOfOverlayView() -> CGRect {
        guard let containerView = containerView else {
            return overlayView.frame
        }

        let presentedHeight = calculateSizeOfPresentedView(
            inParentWithSize: (containerView.bounds.width, containerView.bounds.height)
        ).h
        let presentedOverlayHeight =
            presentedHeight +
            configuration.overlayOffset

        var finalFrame = overlayView.frame
        finalFrame.origin.y =
            containerView.bounds.height -
            presentedOverlayHeight -
            modalBottomPadding

        return finalFrame
    }
}
