// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol LaunchController: AnyObject, AppLaunchable, NotificationObserver {
    func firstLaunch()
    func continueAfterEnterForeground()
    func continueAfterEnterBackground()
}

extension LaunchController {
    public func observeNotifications() {
        observe(notificationWith: UIApplication.willEnterForegroundNotification) { [unowned self] _ in
            self.continueAfterEnterForeground()
        }
        observe(notificationWith: UIApplication.didEnterBackgroundNotification) { [unowned self] _ in
            self.continueAfterEnterBackground()
        }
    }
}

public protocol AuthenticatableLaunchController: LaunchController {
    /// <note> It is recommended to be retained as a weak reference.
    var listener: AuthenticatableLaunchControllerListener? { get set }

    func continueAfterSignUp()
    func continueAfterSignIn()
    func continueAfterReauthentication(first: Bool)
    func signoutAndRelaunch()
}

public protocol AuthenticatableLaunchControllerListener: AnyObject {
    func launchControllerDidStart<T: LaunchController>(_ launchController: T)
    func launchControllerDidSignUp<T: LaunchController>(_ launchController: T)
    func launchControllerDidSignIn<T: LaunchController>(_ launchController: T)
    func launchControllerWillReauthenticate<T: LaunchController>(_ launchController: T)
    func launchControllerDidReauthenticate<T: LaunchController>(_ launchController: T)
    func launchControllerWillDeauthenticate<T: LaunchController>(_ launchController: T)
    func launchControllerDidDeauthenticate<T: LaunchController>(_ launchController: T)
}
