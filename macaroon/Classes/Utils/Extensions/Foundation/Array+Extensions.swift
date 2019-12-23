// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension Array {
    public func last<Value>(_ keyPath: KeyPath<Element, Value?>) -> Value? {
        let elem = last { $0[keyPath: keyPath] != nil }
        return elem?[keyPath: keyPath]
    }

    public func last<Value>(_ keyPath: KeyPath<Element, Value>) -> Value? {
        return last?[keyPath: keyPath]
    }
}
