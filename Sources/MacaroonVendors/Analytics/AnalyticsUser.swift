// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils

public protocol AnalyticsUser: Printable {
    associatedtype Metadata: AnalyticsMetadata

    var id: String { get }
    var metadata: Metadata { get }
}

extension AnalyticsUser {
    public var debugDescription: String {
        return [
            "User#\(id)",
            metadata.debugDescription
        ].joined(separator: "\n")
    }
}
