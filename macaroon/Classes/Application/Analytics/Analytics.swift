// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol Analytics: AnyObject, Decodable, ExpressibleByNilLiteral {
    var services: [AnalyticsService] { get }

    /// <note> The `first` parameter should be `true` when a non-nil user is registered for the first time, i.e. after sign-up.
    func register<T: AnalyticsTrackableUser>(user: T?, first: Bool)
    func track<T: AnalyticsTrackableScreen>(_ screen: T)
    func track<T: AnalyticsTrackableEvent>(_ event: T)
    func unregisterUser()
}

extension Analytics {
    public func register<T: AnalyticsTrackableUser>(user: T?, first: Bool) {
        services.forEach { $0.register(user: user, first: first) }
    }

    public func track<T: AnalyticsTrackableScreen>(_ screen: T) {
        services.forEach {
            if !$0.canTrack(screen) { return }
            $0.track(screen)
        }
    }

    public func track<T: AnalyticsTrackableEvent>(_ event: T) {
        services.forEach {
            if !$0.canTrack(event) { return }
            $0.track(event)
        }
    }

    public func unregisterUser() {
        services.forEach { $0.unregisterUser() }
    }
}
