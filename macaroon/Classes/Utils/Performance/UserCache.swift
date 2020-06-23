// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public class UserCache {
    private let userDefaults = UserDefaults.standard

    public init() { }

    public func getObject<T>(for key: UserCacheKey) -> T? {
        return userDefaults.object(forKey: key.decoded()) as? T
    }

    public func set<T>(object: T, for key: UserCacheKey) {
        userDefaults.set(object, forKey: key.decoded())
        userDefaults.synchronize()
    }

    public func removeObject(for key: UserCacheKey) {
        userDefaults.removeObject(forKey: key.decoded())
        userDefaults.synchronize()
    }
}

public protocol UserCacheKey {
    func decoded() -> String
}

extension UserCacheKey where Self: RawRepresentable, Self.RawValue == String {
    public func decoded() -> String {
        return rawValue
    }
}

extension String: UserCacheKey {
    public func decoded() -> String {
        return self
    }
}
