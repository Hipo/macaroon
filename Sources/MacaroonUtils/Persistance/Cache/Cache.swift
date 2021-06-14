// Copyright © Hipolabs. All rights reserved.

import Foundation

public protocol Cache: AnyObject {
    associatedtype Key: CacheKey

    subscript<T>(object key: Key) -> T? { get set }
    subscript<T: JSONModel>(model key: Key) -> T? { get set }

    func remove(
        for key: Key
    )
}

extension Cache {
    public func removeAll<T: Sequence>(
        for keys: T
    ) where T.Element == Key {
        keys.forEach(remove)
    }
}

public protocol CacheKey {
    func cacheEncoded() -> String
}

extension CacheKey where Self: RawRepresentable, RawValue == String {
    public func cacheEncoded() -> String {
        return rawValue
    }
}

extension CacheKey where Self: RawRepresentable, RawValue == Int {
    public func cacheEncoded() -> String {
        return String(rawValue)
    }
}

extension String: CacheKey {
    public func cacheEncoded() -> String {
        return self
    }
}
