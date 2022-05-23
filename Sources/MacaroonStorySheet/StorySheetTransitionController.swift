// Copyright © 2019 hipolabs. All rights reserved.

/// <src>
/// https://danielgauthier.me/2020/02/24/vctransitions1.html

import Foundation
import UIKit

open class StorySheetTransitionController:
    NSObject,
    UIViewControllerTransitioningDelegate {
    public var presentationConfiguration: StorySheetPresentationConfiguration

    public init(
        presentingViewController: UIViewController,
        presentationConfiguration: StorySheetPresentationConfiguration = StorySheetPresentationConfiguration(),
        completion: (() -> Void)? = nil
    ) {
        self.presentationConfiguration = presentationConfiguration

        super.init()
    }

    /// <mark>
    /// UIViewControllerTransitioningDelegate
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return StorySheetPresentationController(
            presentedViewController: presented,
            presentingViewController: presenting,
            configuration: presentationConfiguration
        )
    }

    open func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return StorySheetAnimator(isPresenting: true)
    }

    open func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return StorySheetAnimator(isPresenting: false)
    }
}
