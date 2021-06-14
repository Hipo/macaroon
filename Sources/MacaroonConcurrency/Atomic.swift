// Copyright © 2019 hipolabs. All rights reserved.

/// <src>
/// https://www.vadimbulavin.com/swift-atomic-properties-with-property-wrappers/

import Foundation
import MacaroonUtils

@propertyWrapper
public final class Atomic<Value> {
    public var wrappedValue: Value {
        get { queue.sync { value } }
        set { crash("Unavailable") }
    }
    public var projectedValue: Atomic<Value> {
        return self
    }

    private var value: Value

    private let queue: DispatchQueue

    public init(
        wrappedValue: Value,
        identifier: String
    ) {
        self.value = wrappedValue
        self.queue =
            DispatchQueue(label: "\(Bundle.main.bundleIdentifier.someString).\(identifier)")
    }

    public func modify(
        _ transform: (inout Value) -> Void
    ) {
        queue.sync { transform(&value) }
    }
}
