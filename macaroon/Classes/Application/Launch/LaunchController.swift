// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol LaunchController: AnyObject, NotificationObserver {
    func firstLaunch()
    func continueAfterEnterForeground()
    func continueAfterEnterBackground()
    func continueAfterBecomeActive()
    func continueAfterResignActive()
}

extension LaunchController {
    public func continueAfterEnterForeground() { }
    public func continueAfterEnterBackground() { }
    public func continueAfterBecomeActive() { }
    public func continueAfterResignActive() { }
}

extension LaunchController {
    public func observeNotifications() {
        observe(notificationWith: UIApplication.willEnterForegroundNotification) { [unowned self] _ in
            self.continueAfterEnterForeground()
        }
        observe(notificationWith: UIApplication.didEnterBackgroundNotification) { [unowned self] _ in
            self.continueAfterEnterBackground()
        }
        observe(notificationWith: UIApplication.didBecomeActiveNotification) { [unowned self] _ in
            self.continueAfterBecomeActive()
        }
        observe(notificationWith: UIApplication.willResignActiveNotification) { [unowned self] _ in
            self.continueAfterResignActive()
        }
    }
}
