// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension Optional {
    public func unwrap<T>(_ transform: (Wrapped) -> T) -> T? {
        return map(transform)
    }

    public func unwrap<T>(_ transform: (Wrapped) -> T?) -> T? {
        return flatMap(transform)
    }

    public func unwrap<T>(ifPresent transform: (Wrapped) -> T, or someValue: T) -> T {
        return map(transform) ?? someValue
    }

    public func unwrap<T>(ifPresent transform: (Wrapped) -> T?, or someValue: T) -> T {
        return flatMap(transform) ?? someValue
    }

    public func unwrap<T>(_ keyPath: KeyPath<Wrapped, T>) -> T? {
        return map { $0[keyPath: keyPath] }
    }

    public func unwrap<T>(_ keyPath: KeyPath<Wrapped, T?>) -> T? {
        return flatMap { $0[keyPath: keyPath] }
    }

    public func unwrap<T>(ifPresent keyPath: KeyPath<Wrapped, T>, or someValue: T) -> T {
        return map { $0[keyPath: keyPath] } ?? someValue
    }

    public func unwrap<T>(ifPresent keyPath: KeyPath<Wrapped, T?>, or someValue: T) -> T {
        return flatMap { $0[keyPath: keyPath] } ?? someValue
    }

    public func unwrapConditionally(where predicate: (Wrapped) -> Bool) -> Wrapped? {
        return unwrap { predicate($0) ? $0 : nil }
    }
}

extension Optional {
    public func executeIfPresent(_ operation: (Wrapped) -> Void) {
        if let value = self {
            operation(value)
        }
    }

    public func execute(ifPresent operation: (Wrapped) -> Void, else elseOperation: () -> Void) {
        if let value = self { operation(value) }
        else { elseOperation() }
    }
}

extension Optional where Wrapped == String {
    public var nonNil: String {
        return self ?? ""
    }
}

extension Optional where Wrapped == EditText {
    public var nonNil: EditText {
        return self ?? .normal("")
    }
}
