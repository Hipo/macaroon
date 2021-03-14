// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol Analytics: AnyObject {
    var platforms: [AnalyticsPlatform] { get }

    /// <note> The `first` parameter should be `true` when a non-nil user is registered for the first time, i.e. after sign-up.
    func identify<T: AnalyticsTrackableUser>(user: T, first: Bool)
    func track<T: AnalyticsTrackableScreen>(_ screen: T)
    func track<T: AnalyticsTrackableEvent>(_ event: T)
    func reset()
}

extension Analytics {
    public func identify<T: AnalyticsTrackableUser>(user: T, first: Bool) {
        platforms.forEach { $0.identify(user: user, first: first) }
    }

    public func track<T: AnalyticsTrackableScreen>(_ screen: T) {
        platforms.forEach {
            if !$0.canTrack(screen) {
                return
            }

            $0.track(screen)
        }
    }

    public func track<T: AnalyticsTrackableEvent>(_ event: T) {
        platforms.forEach {
            if !$0.canTrack(event) {
                return
            }

            $0.track(event)
        }
    }

    public func reset() {
        platforms.forEach { $0.reset() }
    }
}
