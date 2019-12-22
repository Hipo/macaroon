// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol NotificationBroadcast { }

extension NotificationBroadcast {
    public func post(notificationWith name: Notification.Name) {
        NotificationCenter.default.post(Notification(name: name))
    }
}
