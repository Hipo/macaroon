// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol AppLaunchController: AnyObject, AppLaunchable, NotificationObserver {
    /// <note> It is recommended to be retained as a weak reference.
    var listener: AppLaunchControllerListener? { get set }

    init(appLaunchArgs: SomeAppLaunchArgs)

    func firstLaunch()
    func continueAfterSignUp()
    func continueAfterSignIn()
    func continueAfterReauthentication()
    func continueAfterEnterForeground()
    func continueAfterEnterBackground()
    func signoutAndRelaunch()
}

extension AppLaunchController {
    public func observeNotifications() {
        observe(notificationWith: UIApplication.willEnterForegroundNotification) { [unowned self] _ in
            self.continueAfterEnterForeground()
        }
        observe(notificationWith: UIApplication.didEnterBackgroundNotification) { [unowned self] _ in
            self.continueAfterEnterBackground()
        }
    }
}

public protocol AppLaunchControllerListener: AnyObject {
    func launchControllerDidStart<T: AppLaunchController>(_ launchController: T)
    func launchControllerDidSignUp<T: AppLaunchController>(_ launchController: T)
    func launchControllerDidSignIn<T: AppLaunchController>(_ launchController: T)
    func launchControllerWillReauthenticate<T: AppLaunchController>(_ launchController: T)
    func launchControllerDidReauthenticate<T: AppLaunchController>(_ launchController: T)
    func launchControllerWillDeauthenticate<T: AppLaunchController>(_ launchController: T)
    func launchControllerDidDeauthenticate<T: AppLaunchController>(_ launchController: T)
}
