// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AnalyticsService: AnyObject, Decodable, ExpressibleByNilLiteral {
    func register<T: AnalyticsTrackableUser>(user: T?, first: Bool)
    func canTrack<T: AnalyticsTrackableScreen>(_ screen: T) -> Bool
    func track<T: AnalyticsTrackableScreen>(_ screen: T)
    func canTrack<T: AnalyticsTrackableEvent>(_ event: T) -> Bool
    func track<T: AnalyticsTrackableEvent>(_ event: T)
    func unregisterUser()
}
