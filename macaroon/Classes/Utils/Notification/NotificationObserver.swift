// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol NotificationObserver: AnyObject {
    var observations: [NSObjectProtocol] { get set }

    func observeNotifications()
}

extension NotificationObserver {
    public typealias NotificationHandler = (Notification) -> Void

    public func observe(notificationWith name: Notification.Name, onNotified handler: @escaping NotificationHandler) {
        observe(notificationWith: name, by: nil, at: OperationQueue.main, onNotified: handler)
    }

    public func observe(notificationWith name: Notification.Name, by object: Any?, at queue: OperationQueue?, onNotified handler: @escaping NotificationHandler) {
        observations.append(
            NotificationCenter.default.addObserver(forName: name, object: object, queue: queue) { handler($0) }
        )
    }

    public func notifyWhenApplicationWillEnterForeground(_ handler: @escaping NotificationHandler) {
        observe(notificationWith: UIApplication.willEnterForegroundNotification, onNotified: handler)
    }

    public func notifyWhenApplicationDidEnterBackground(_ handler: @escaping NotificationHandler) {
        observe(notificationWith: UIApplication.didEnterBackgroundNotification, onNotified: handler)
    }

    public func unobserveNotifications() {
        observations.forEach { NotificationCenter.default.removeObserver($0) }
        observations = []
    }
}
