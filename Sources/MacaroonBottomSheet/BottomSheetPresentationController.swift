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
        return (presentedContentViewController as? BottomSheetPresentable)?.presentedScrollView
    }
    public var presentedScrollContentView: UIView? {
        return (presentedContentViewController as? BottomSheetPresentable)?.presentedScrollContentView
    }
    public var modalHeight: ModalHeight {
        return (presentedContentViewController as? ModalCustomPresentable)?.modalHeight ?? .compressed
    }
    public var modalBottomPadding: LayoutMetric {
        return (presentedContentViewController as? BottomSheetPresentable)?.modalBottomPadding ?? 0
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
        return (0, parentSize.h - size.h - modalBottomPadding)
    }

    open override func calculateSizeOfPresentedView(
        inParentWithSize parentSize: LayoutSize
    ) -> LayoutSize {
        let targetWidth = parentSize.w
        let targetHeight: LayoutMetric

        switch modalHeight {
        case .compressed,
             .expanded:
            /// <note>
            /// Use `presentedContentViewController` to calculate the height because
            /// navigation controller gives us 0. A preferred height should be set explicitly in order
            /// to add its height into the calculations.
            let fittingSize: CGSize

            if modalHeight == .compressed {
                fittingSize = CGSize((targetWidth, UIView.layoutFittingCompressedSize.height))
            } else {
                fittingSize = CGSize((targetWidth, UIView.layoutFittingExpandedSize.height))
            }

            if let presentedScrollView = presentedScrollView,
               let presentedScrollContentView = presentedScrollContentView {
                let contentHeight =
                    presentedScrollContentView.systemLayoutSizeFitting(
                        fittingSize,
                        withHorizontalFittingPriority: .required,
                        verticalFittingPriority: .defaultLow
                    ).height

                if modalBottomPadding > 0 {
                    targetHeight = contentHeight + presentedScrollView.contentInset.y
                } else {
                    targetHeight = contentHeight + presentedScrollView.contentInset.y + presentedScrollView.compactSafeAreaInsets.bottom
                }
            } else {
                targetHeight =
                    presentedContentView.systemLayoutSizeFitting(
                        fittingSize,
                        withHorizontalFittingPriority: .required,
                        verticalFittingPriority: .defaultLow
                    ).height
            }
        case .proportional(let proportion):
            targetHeight = parentSize.h * proportion
        case .preferred(let preferredHeight):
            /// <note>
            /// Return a height without the safe area inset.
            if modalBottomPadding == 0 {
                targetHeight = preferredHeight + (containerView?.compactSafeAreaInsets.bottom ?? 0)
            } else {
                /// <note>
                /// Return safe area inset with `modalBottomPadding`.
                targetHeight = preferredHeight
            }
        }

        let maxHeight = (parentSize.h * 0.93) - modalBottomPadding

        return (targetWidth, (max(0, min(targetHeight, maxHeight))).ceil())
    }

    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        overlayView.frame = calculateFinalFrameOfOverlayView()
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
        let bool = presentedScrollView.unwrap(
            \.isScrollAtTop,
            or: true
        )
        return bool
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
