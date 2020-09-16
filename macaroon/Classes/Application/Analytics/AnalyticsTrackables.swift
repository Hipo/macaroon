// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AnalyticsTrackableUser: AnalyticsTrackableMetadata {
    var id: String { get }
}

public protocol AnalyticsTrackableScreen: AnalyticsTrackableMetadata {
    var name: String { get }
}

extension AnalyticsTrackableScreen {
    public var description: String {
        return "\(name) \n \(analyticsMetadata.description)"
    }
}

public protocol AnalyticsTrackableEvent: AnalyticsTrackableMetadata {
    associatedtype EventType: AnalyticsTrackableEventType

    var type: EventType { get }
}

extension AnalyticsTrackableEvent {
    public var description: String {
        return "\(type.description) \n \(analyticsMetadata.description)"
    }
}

public protocol AnalyticsTrackableEventType:  CustomStringConvertible { }

extension AnalyticsTrackableEventType where Self: RawRepresentable, Self.RawValue == String {
    public var description: String {
        return rawValue
    }
}

public protocol AnalyticsTrackableMetadata: CustomStringConvertible {
    associatedtype Key: AnalyticsTrackableMetadataKey

    var analyticsMetadata: KeyValuePairs<Key, Any> { get }
}

extension AnalyticsTrackableMetadata {
    public var description: String {
        return analyticsMetadata.description
    }
}

public protocol AnalyticsTrackableMetadataKey: CustomStringConvertible { }

extension AnalyticsTrackableMetadataKey where Self: RawRepresentable, Self.RawValue == String {
    public var description: String {
        return rawValue
    }
}
