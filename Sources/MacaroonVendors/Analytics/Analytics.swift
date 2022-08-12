// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

/// <todo>
/// May use `some`, `any` when Swift 5.7 is out.
public protocol Analytics: AnyObject {
    var providers: [AnalyticsProvider] { get }

    func setup()

    func identify<T: AnalyticsUser>(
        _ user: T
    )
    func update<T: AnalyticsUser>(
        _ user: T
    )

    func track<T: AnalyticsScreen>(
        _ screen: T
    )

    func track<T: AnalyticsEvent>(
        _ event: T
    )

    func reset()
}

extension Analytics {
    public func setup() {
        for provider in providers {
            provider.setup()
        }
    }

    public func identify<T: AnalyticsUser>(
        _ user: T
    ) {
        for provider in providers {
            provider.identify(user)
        }
    }

    public func update<T: AnalyticsUser>(
        _ user: T
    ) {
        for provider in providers {
            provider.update(user)
        }
    }

    public func track<T: AnalyticsScreen>(
        _ screen: T
    ) {
        for provider in providers where provider.canTrack(screen) {
            provider.track(screen)
        }
    }

    public func track<T: AnalyticsEvent>(
        _ event: T
    ) {
        for provider in providers where provider.canTrack(event) {
            provider.track(event)
        }
    }

    public func reset() {
        for provider in providers {
            provider.reset()
        }
    }
}
