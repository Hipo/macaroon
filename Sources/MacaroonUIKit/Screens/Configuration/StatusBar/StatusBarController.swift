// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

open class StatusBarController: ScreenLifeCycleObserver {
    /// <note>
    /// False for most cases. Don't set it directly, instead set `hidesStatusBarOnAppeared` and
    /// `hidesStatusBarOnPresented` respectively.
    ///
    /// <sample>
    /// If a screen is pushed while the status bar is hidden, this variable should be true for
    /// the screen to prevent an unneeded status bar animation.
    public var isStatusBarHidden = false

    public var hidesStatusBarOnAppeared = false

    /// <note>
    /// If the screen is being presented, then the value will be counted primarily.
    public var hidesStatusBarOnPresented = false
    
    public weak var screen: Screen! {
        didSet { screen.add(lifeCycleObserver: self) }
    }
    
    public init() {}
}

extension StatusBarController {
    /// <note>
    /// Called in `viewWillAppear(:)`
    public func setNeedsStatusBarAppearanceUpdateOnBeingAppeared() {
        if hidesStatusBarOnPresented,
           screen.presentingViewController != nil {
            if isStatusBarHidden {
                return
            }

            isStatusBarHidden = true
        } else {
            if isStatusBarHidden == hidesStatusBarOnAppeared {
                return
            }

            isStatusBarHidden = hidesStatusBarOnAppeared
        }

        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) {
            [unowned self] in

            self.screen.setNeedsStatusBarAppearanceUpdate()
        }
        animator.startAnimation()
    }

    /// <note>
    /// Called in `viewWillDisappear(:)`
    public func setNeedsStatusBarAppearanceUpdateOnBeingDisappeared() {
        guard var presentedScreen = screen.presentedViewController else {
            return
        }

        if let presentedNavigationContainer = presentedScreen as? UINavigationController,
           let presentedNavigationScreen = presentedNavigationContainer.viewControllers.last {
            presentedScreen = presentedNavigationScreen
        }

        guard let configurablePresentedScreen = presentedScreen as? StatusBarControlling else {
            return
        }

        if configurablePresentedScreen.statusBarController.hidesStatusBarOnPresented ||
            configurablePresentedScreen.statusBarController.hidesStatusBarOnAppeared {
            isStatusBarHidden = true
        }
    }
}


/// <mark>
/// Hashable
extension StatusBarController {
    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(ObjectIdentifier(self))
    }

    public static func == (
        lhs: StatusBarController,
        rhs: StatusBarController
    ) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

protocol StatusBarControlling: UIViewController {
    var statusBarController: StatusBarController { get }
}
