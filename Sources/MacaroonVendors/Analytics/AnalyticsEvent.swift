// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils

public protocol AnalyticsEvent: Printable {
    associatedtype Name: AnalyticsEventName
    associatedtype Metadata: AnalyticsMetadata

    var name: Name { get }
    var metadata: Metadata { get }
}

extension AnalyticsEvent {
    public var debugDescription: String {
        return [
            "Event#\(name.debugDescription)",
            metadata.debugDescription
        ].joined(separator: "\n")
    }
}

public protocol AnalyticsEventName:
    RawRepresentable,
    Printable
where Self.RawValue == String {}
