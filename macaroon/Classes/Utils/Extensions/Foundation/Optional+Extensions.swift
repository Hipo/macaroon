// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension Optional {
    public func unwrap(or someValue: Wrapped) -> Wrapped {
        return self ?? someValue
    }

    public func unwrap<T>(either transform: (Wrapped) -> T, or someValue: T) -> T {
        return map(transform) ?? someValue
    }

    public func unwrap<T>(either keyPath: KeyPath<Wrapped, T>, or someValue: T) -> T {
        return unwrap(either: { $0[keyPath: keyPath] }, or: someValue)
    }

    public func unwrap<T>(either keyPath: KeyPath<Wrapped, T?>, or someValue: T) -> T {
        return unwrap(either: { $0[keyPath: keyPath] ?? someValue }, or: someValue)
    }

    public func unwrapConditionally<T>(either transform: (Wrapped) -> T, or someValue: T? = nil) -> T? {
        return map(transform) ?? someValue
    }

    public func unwrapConditionally(_ condition: (Wrapped) -> Bool) -> Wrapped? {
        return unwrap(either: { condition($0) ? $0 : nil }, or: nil)
    }
}
