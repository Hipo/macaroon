// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension Array {
    public subscript (safe index: Index?) -> Element? {
        if let index = index, indices.contains(index) {
            return self[index]
        }
        return nil
    }
}

extension Array {
    public func firstIndexOfElement<T: Equatable>(equalsTo other: Element?, on keyPath: KeyPath<Element, T>) -> Index? {
        if let other = other {
            return firstIndex { $0[keyPath: keyPath] == other[keyPath: keyPath] }
        }
        return nil
    }
}

extension Array {
    public func values<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }

    public func compactValues<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
        return compactMap { $0[keyPath: keyPath] }
    }

    public func compactLast<T>(_ keyPath: KeyPath<Element, T?>) -> T? {
        let elem = last { $0[keyPath: keyPath] != nil }
        return elem?[keyPath: keyPath]
    }

    public func compactLast<T>(_ keyPath: KeyPath<Element, T>) -> T? {
        return last?[keyPath: keyPath]
    }
}
