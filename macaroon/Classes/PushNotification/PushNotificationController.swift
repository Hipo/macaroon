// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UserNotifications

open class PushNotificationController {
    public private(set) var pushToken: String?

    public init() { }

    open func registerDevice(options: UNAuthorizationOptions = [.alert, .sound, .badge]) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: options) { isGranted, _ in
            if !isGranted { return }

            notificationCenter.getNotificationSettings { settings in
                if settings.authorizationStatus != .authorized { return }

                asyncMain { UIApplication.shared.registerForRemoteNotifications() }
            }
        }
    }

    open func unregisterDevice() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }

    open func saveDevice(_ deviceToken: Data) {
        pushToken = deviceToken
            .map { String(format: "%02.2hhx", $0) }
            .joined()
    }

    open func deleteDevice() {
        pushToken = nil
    }
}
