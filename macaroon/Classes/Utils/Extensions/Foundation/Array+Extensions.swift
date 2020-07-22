// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension Array {
    public var lastIndex: Index {
        if startIndex == endIndex {
            return endIndex
        }
        return index(before: endIndex)
    }
}

extension Array {
    public subscript (safe index: Index?) -> Element? {
        if let index = index, indices.contains(index) {
            return self[index]
        }
        return nil
    }
}

extension Array {
    public func first<T: Equatable>(of keyPath: KeyPath<Element, T>, equalsTo value: T) -> Element? {
        return first(where: { $0[keyPath: keyPath] == value })
    }

    public func first<T: Equatable>(of keyPath: KeyPath<Element, T>, equalsTo value: T?) -> Element? {
        return first(where: { $0[keyPath: keyPath] == value })
    }

    public func first<T: Equatable>(of keyPath: KeyPath<Element, T?>, equalsTo value: T) -> Element? {
        return first(where: { $0[keyPath: keyPath] == value })
    }

    public func first<T: Equatable>(of keyPath: KeyPath<Element, T?>, equalsTo value: T?) -> Element? {
        return first(where: { $0[keyPath: keyPath] != nil && $0[keyPath: keyPath] == value })
    }

    public func firstIndex<T: Equatable>(of other: Element?, equals keyPath: KeyPath<Element, T>) -> Index? {
        if let other = other {
            return firstIndex { $0[keyPath: keyPath] == other[keyPath: keyPath] }
        }
        return nil
    }
}

extension Array {
    public func findFirst<T>(_ keyPath: KeyPath<Element, T>, where predicate: (Element) -> Bool) -> T? {
        return first(where: predicate)?[keyPath: keyPath]
    }

    public func findFirst<T>(_ keyPath: KeyPath<Element, T?>, where predicate: (Element) -> Bool) -> T? {
        return first(where: predicate)?[keyPath: keyPath]
    }

    public func findLast<T>(nonNil keyPath: KeyPath<Element, T>) -> T? {
        let elem = last { $0[keyPath: keyPath] != nil }
        return elem?[keyPath: keyPath]
    }

    public func findLast<T>(nonNil keyPath: KeyPath<Element, T?>) -> T? {
        let elem = last { $0[keyPath: keyPath] != nil }
        return elem?[keyPath: keyPath]
    }
}
