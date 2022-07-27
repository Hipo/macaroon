// Copyright © 2019 hipolabs. All rights reserved.

/// <src>
/// https://danielgauthier.me/2020/02/24/vctransitions1.html

import Foundation
import UIKit

open class AlertUITransitionController:
    NSObject,
    UIViewControllerTransitioningDelegate {
    public let configuration: AlertUIConfiguration

    private let animator: AlertUIAnimationController

    public init(
        configuration: AlertUIConfiguration
    ) {
        self.configuration = configuration
        self.animator = AlertUIAnimationController(configuration: configuration)

        super.init()
    }

    /// <mark>
    /// UIViewControllerTransitioningDelegate
    open func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return AlertUIPresentationController(
            presentedViewController: presented,
            presentingViewController: presenting,
            configuration: configuration
        )
    }

    open func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = true
        return animator
    }

    open func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = false
        return animator
    }
}
