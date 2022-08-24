// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import MacaroonUtils
import UIKit

open class AlertUIPresentationController: ModalPresentationController<AlertUIConfiguration> {
    public let presentedContentViewController: UIViewController

    public let modalHeight: ModalHeight

    private var cachedContentAreaHeight: CGFloat?
    private var contentAreaInsets: UIEdgeInsets {
        let contentConfigurableViewController = presentedContentViewController as? AlertUIContentConfigurable
        return contentConfigurableViewController?.contentAreaInsets ?? configuration.contentAreaInsets
    }

    private var safeAreaInsets: UIEdgeInsets {
        return containerView?.safeAreaInsets ?? .zero
    }

    public override init(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?,
        configuration: AlertUIConfiguration
    ) {
        let navigationController = presentedViewController as? UINavigationController
        let contentViewController = navigationController?.viewControllers.last ?? presentedViewController
        self.presentedContentViewController = contentViewController

        let contentConfigurableViewController = presentedContentViewController as? AlertUIContentConfigurable
        self.modalHeight = contentConfigurableViewController?.modalHeight ?? .compressed

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
        let originX = contentAreaInsets.left
        let originY =
            parentSize.h -
            size.h -
            contentAreaInsets.bottom -
            safeAreaInsets.bottom
        return (originX, originY)
    }

    open override func calculateSizeOfPresentedView(
        inParentWithSize parentSize: LayoutSize
    ) -> LayoutSize {
        let targetWidth = parentSize.w - contentAreaInsets.x
        let size = CGSize(width: parentSize.w, height: parentSize.h)
        let preferredHeight = calculatePreferredPresentedAreaHeight(inParentWithSize: size)
        let maxHeight = calculateMaxPresentedAreaHeight(inParentWithSize: size)
        let targetHeight = max(0, min(preferredHeight, maxHeight))

        return (targetWidth, targetHeight.ceil())
    }

    open override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        setScrollEnabledIfNeeded()
    }
}

extension AlertUIPresentationController {
    private func setScrollEnabledIfNeeded() {
        let contentConfigurableViewController = presentedContentViewController as? AlertUIScrollContentConfigurable

        guard let scrollView = contentConfigurableViewController?.scrollView else { return }

        let size = presentationBounds.size
        let preferredHeight = calculatePreferredPresentedAreaHeight(inParentWithSize: size)
        let maxHeight = calculateMaxPresentedAreaHeight(inParentWithSize: size)
        scrollView.isScrollEnabled = preferredHeight > maxHeight
    }
}

extension AlertUIPresentationController {
    private func calculatePreferredPresentedAreaHeight(
        inParentWithSize parentSize: CGSize
    ) -> CGFloat {
        let targetWidth = parentSize.width - contentAreaInsets.x

        let preferredHeight: CGFloat
        switch modalHeight {
        case .compressed:
            let navigationAreaHeight = calculateNavigationAreaHeight()
            let contentAreaHeight = calculateContentAreaCompressedHeightFitting(targetWidth)
            preferredHeight = navigationAreaHeight + contentAreaHeight

            cachedContentAreaHeight = contentAreaHeight
        case .expanded:
            let navigationAreaHeight = calculateNavigationAreaHeight()
            let contentAreaHeight = calculateContentAreaExpandedHeightFitting(targetWidth)
            preferredHeight = navigationAreaHeight + contentAreaHeight

            cachedContentAreaHeight = contentAreaHeight
        case .proportional(let proportion):
            let contentAreaHeight = parentSize.height * proportion
            preferredHeight = contentAreaHeight

            cachedContentAreaHeight = contentAreaHeight
        case .preferred(let height):
            let contentAreaHeight = height
            preferredHeight = contentAreaHeight

            cachedContentAreaHeight = contentAreaHeight
        }

        return preferredHeight
    }

    private func calculateMaxPresentedAreaHeight(
        inParentWithSize parentSize: CGSize
    ) -> CGFloat {
        let preferredMaxHeight =
            parentSize.height -
            contentAreaInsets.y -
            safeAreaInsets.y
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

        if let customPresentedContentViewController = presentedContentViewController as? AlertUIContentConfigurable {
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
