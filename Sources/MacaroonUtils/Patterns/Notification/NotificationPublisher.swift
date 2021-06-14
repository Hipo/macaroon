// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol NotificationPublisher { }

extension NotificationPublisher {
    public func publish(
        notification name: Notification.Name
    ) {
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
