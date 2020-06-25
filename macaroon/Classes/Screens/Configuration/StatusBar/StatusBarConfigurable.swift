// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol StatusBarConfigurable: AnyObject {
    /// <note> False for most cases. Don't set it directly, instead set `hidesStatusBarOnAppeared` and `hidesStatusBarOnPresented` respectively.
    /// <sample> If a screen is pushed while the status bar is hidden, this variable should be true for the screen to prevent an unneeded status bar animation.
    var isStatusBarHidden: Bool { get set }

    var hidesStatusBarOnAppeared: Bool { get set }
    /// <note> If the screen is being presented, then the value will be counted primarily.
    var hidesStatusBarOnPresented: Bool { get set }
}

extension StatusBarConfigurable where Self: UIViewController {
    /// <note> Called in `viewWillAppear(:)`
    public func setNeedsStatusBarAppearanceUpdateOnAppearing() {
        if hidesStatusBarOnPresented,
           presentingViewController != nil {
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
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [unowned self] in
            self.setNeedsStatusBarAppearanceUpdate()
        }
        animator.startAnimation()
    }

    /// <note> Called in `viewWillDisappear(:)`
    public func setNeedsStatusBarAppearanceUpdateOnDisappearing() {
        if let presentedScreen = (presentedViewController as? UINavigationController)?.topViewController ?? presentedViewController,
           let configurablePresentedScreen = presentedScreen as? StatusBarConfigurable,
           configurablePresentedScreen.hidesStatusBarOnPresented || configurablePresentedScreen.hidesStatusBarOnAppeared {
            isStatusBarHidden = true
        }
    }
}
