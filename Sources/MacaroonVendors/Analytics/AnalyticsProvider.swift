// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

/// <todo>
/// May use `some`, `any` when Swift 5.7 is out.
public protocol AnalyticsProvider: AnyObject {
    func setup()

    func identify<T: AnalyticsUser>(
        _ user: T
    )
    func update<T: AnalyticsUser>(
        _ user: T
    )

    func canTrack<T: AnalyticsScreen>(
        _ screen: T
    ) -> Bool
    func track<T: AnalyticsScreen>(
        _ screen: T
    )

    func canTrack<T: AnalyticsEvent>(
        _ event: T
    ) -> Bool
    func track<T: AnalyticsEvent>(
        _ event: T
    )
    
    func reset()
}
