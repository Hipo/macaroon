// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension Optional {
    public func unwrap(or someValue: Wrapped) -> Wrapped {
        return self ?? someValue
    }

    public func unwrap<T>(either transform: (Wrapped) -> T, or someValue: T) -> T {
        return map(transform) ?? someValue
    }

    public func unwrap<T>(_ keyPath: KeyPath<Wrapped, T>, or someValue: T) -> T {
        return unwrap(either: { $0[keyPath: keyPath] }, or: someValue)
    }

    public func unwrap<T>(_ keyPath: KeyPath<Wrapped, T?>, or someValue: T) -> T {
        return unwrap(either: { $0[keyPath: keyPath] ?? someValue }, or: someValue)
    }

    public func unwrapIfPresent<T>(either transform: (Wrapped) -> T, or someValue: T? = nil) -> T? {
        return map(transform) ?? someValue
    }

    public func unwrapIfPresent<T>(either transform: (Wrapped) -> T?, or someValue: T? = nil) -> T? {
        return map(transform) ?? someValue
    }

    public func unwrapIfPresent<T>(_ keyPath: KeyPath<Wrapped, T>, or someValue: T? = nil) -> T? {
        return unwrapIfPresent(either: { $0[keyPath: keyPath] }, or: someValue)
    }

    public func unwrapIfPresent<T>(_ keyPath: KeyPath<Wrapped, T?>, or someValue: T? = nil) -> T? {
        return unwrapIfPresent(either: { $0[keyPath: keyPath] }, or: someValue)
    }

    public func unwrapConditionally(where predicate: (Wrapped) -> Bool) -> Wrapped? {
        return unwrap(either: { predicate($0) ? $0 : nil }, or: nil)
    }
}

extension Optional {
    public func `continue`(ifPresent operation: (Wrapped) -> Void, else elseOperation: (() -> Void)? = nil) {
        if let value = self { operation(value) }
        else { elseOperation?() }
    }
}
