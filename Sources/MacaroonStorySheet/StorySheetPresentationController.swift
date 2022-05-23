// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

open class StorySheetPresentationController:
    ModalPresentationController<StorySheetPresentationConfiguration>,
    UIGestureRecognizerDelegate {
    public private(set) lazy var overlayView = StorySheetOverlayView()

    public var presentedContentViewController: UIViewController {
        let navigationController = presentedViewController as? UINavigationController
        return navigationController?.viewControllers.last ?? presentedViewController
    }
    public var presentedContentView: UIView {
        return presentedContentViewController.view
    }
    public var presentedScrollView: UIScrollView? {
        return (presentedContentViewController as? StorySheetPresentable)?.presentedScrollView
    }
    public var presentedScrollContentView: UIView? {
        return (presentedContentViewController as? StorySheetPresentable)?.presentedScrollContentView
    }
    public var modalHeight: ModalHeight {
        return (presentedContentViewController as? ModalCustomPresentable)?.modalHeight ?? .compressed
    }
    public var modalInset: LayoutMargins {
        return (presentedContentViewController as? StorySheetPresentable)?.storySheetInset ?? configuration.storySheetInset
    }

    open override func calculateOriginOfPresentedView(
        withSize size: LayoutSize,
        inParentWithSize parentSize: LayoutSize
    ) -> LayoutOffset {
        let originY = calculateFinalFrameOfOverlayView().origin.y + configuration.contentMargin.top
        return (modalInset.leading, originY)
    }

    open override func calculateSizeOfPresentedView(
        inParentWithSize parentSize: LayoutSize
    ) -> LayoutSize {
        let targetWidth = parentSize.w - modalInset.leading - modalInset.trailing
        let targetHeight: LayoutMetric

        switch modalHeight {
        case .compressed,
             .expanded:
            /// <note>
            /// Use `presentedContentViewController` to calculate the height because
            /// navigation controller gives us 0. A preferred height should be set explicitly in order
            /// to add its height into the calculations.
            var preferredHeight: CGFloat = 0

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
                
                preferredHeight += contentHeight + presentedScrollView.contentInset.y + presentedScrollView.compactSafeAreaInsets.bottom
            } else {
                preferredHeight +=
                    presentedContentView.systemLayoutSizeFitting(
                        fittingSize,
                        withHorizontalFittingPriority: .required,
                        verticalFittingPriority: .defaultLow
                    ).height
            }

            if let navigationController = presentedViewController as? UINavigationController {
                preferredHeight +=
                    navigationController.navigationBar.bounds.height
            }

            targetHeight = preferredHeight
        case .proportional(let proportion):
            targetHeight = parentSize.h * proportion
        case .preferred(let preferredHeight):
            targetHeight = preferredHeight
        }

        let maxHeight = (parentSize.h * 0.93)

        return (targetWidth, (max(0, min(targetHeight, maxHeight))).ceil())
    }

    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        overlayView.frame = calculateFinalFrameOfOverlayView()
    }

    open override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        addOverlay()
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


extension StorySheetPresentationController {
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
        
        overlayView.frame =
            CGRect(
                x: modalInset.leading,
                y: containerView.bounds.height - modalInset.top - modalInset.bottom,
                width: containerView.bounds.width - modalInset.trailing - modalInset.leading,
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

    private func removeOverlay() {
        var finalFrame = overlayView.frame
        finalFrame.origin.y = presentationBounds.height

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

extension StorySheetPresentationController {
    private func calculateFinalFrameOfOverlayView() -> CGRect {
        guard let containerView = containerView else {
            return overlayView.frame
        }

        let width = containerView.bounds.width - configuration.storySheetInset.leading - configuration.storySheetInset.trailing
        let presentedHeight = calculateSizeOfPresentedView(
            inParentWithSize: (width, containerView.bounds.height)
        ).h
        let presentedOverlayHeight =
        presentedHeight +
        configuration.contentMargin.top +
        configuration.contentMargin.bottom

        var finalFrame = overlayView.frame
        let originY = containerView.bounds.height -
            presentedOverlayHeight -
            modalInset.bottom
        
        finalFrame.origin.y = max(modalInset.top, originY)
            
        finalFrame.origin.x = modalInset.leading
        finalFrame.size = CGSize(width: finalFrame.size.width, height: presentedOverlayHeight)

        return finalFrame
    }
}
