// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils

public protocol AnalyticsScreen: Printable {
    associatedtype Metadata: AnalyticsMetadata

    var name: String { get }
    var metadata: Metadata { get }
}

extension AnalyticsScreen {
    public var debugDescription: String {
        return [
            "Screen#\(name)",
            metadata.debugDescription
        ].joined(separator: "\n")
    }
}
