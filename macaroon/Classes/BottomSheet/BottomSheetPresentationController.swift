// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class BottomSheetPresentationController:
    ModalPresentationController<BottomSheetPresentationConfiguration>,
    UIGestureRecognizerDelegate {
    public private(set) lazy var overlayView = BottomSheetOverlayView()

    public var presentedContentViewController: UIViewController {
        guard
            let presentedNavigationController = presentedViewController as? UINavigationController
        else {
            return presentedViewController
        }

        return presentedNavigationController.viewControllers.last ?? presentedViewController
    }
    public var configurablePresentedContentViewController: BottomSheetPresentable? {
        return presentedContentViewController as? BottomSheetPresentable
    }

    public var presentedScrollView: UIScrollView? {
        return configurablePresentedContentViewController?.presentedScrollView
    }

    public let interactor: BottomSheetInteractor

    public init(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?,
        interactor: BottomSheetInteractor,
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
        return (0, parentSize.h - size.h)
    }

    open override func calculateSizeOfPresentedView(
        inParentWithSize parentSize: LayoutSize
    ) -> LayoutSize {
        let presentedHeight =
            configurablePresentedContentViewController?.presentedHeight ?? .compressed
        let targetWidth = parentSize.w
        let targetHeight: LayoutMetric

        switch presentedHeight {
        case .compressed,
             .expanded:
            /// <note>
            /// Use `presentedContentViewController` to calculate the height becuase navigation
            /// controller gives us 0. A preferred height should be set explicitly in order to
            /// add its height into the calculations.
            if let presentedView = presentedContentViewController.view {
                let fittingHeight =
                    presentedHeight == .compressed
                        ? UIView.layoutFittingCompressedSize.height
                        : UIView.layoutFittingExpandedSize.height
                let fittingSize = CGSize((targetWidth, fittingHeight))

                targetHeight =
                    presentedView.systemLayoutSizeFitting(
                        fittingSize,
                        withHorizontalFittingPriority: .required,
                        verticalFittingPriority: .defaultLow
                    ).height
            } else {
                targetHeight = parentSize.h
            }
        case .proportional(let proportion):
            targetHeight = parentSize.h * proportion
        case .preferred(let preferredHeight):
            targetHeight = preferredHeight
        }

        let maxHeight = parentSize.h * 0.9

        return (targetWidth, (max(0, min(targetHeight, maxHeight))).ceil())
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
        guard let presentedScrollView = presentedScrollView else {
            return true
        }

        return presentedScrollView.isScrollAtTop
    }
}

extension BottomSheetPresentationController {
    private func prepareForInteractiveUse() {
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
        guard
            let containerView = containerView,
            let presentedView = presentedView
        else {
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

        let presentedHeight = calculateSizeOfPresentedView(
            inParentWithSize: (containerView.bounds.width, containerView.bounds.height)
        ).h
        let presentedOverlayHeight =
            presentedHeight +
            containerView.compactSafeAreaInsets.bottom +
            configuration.overlayOffset

        var finalFrame = overlayView.frame
        finalFrame.origin.y = containerView.bounds.height - presentedOverlayHeight

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
        if interactor.inProgress {
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
