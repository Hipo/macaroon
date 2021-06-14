// Copyright © Hipolabs. All rights reserved.

import Foundation

open class HIPUserDefaults<Key: CacheKey>: Cache {
    public let userDefaults: UserDefaults

    public init(
        userDefaults: UserDefaults = UserDefaults.standard
    ) {
        self.userDefaults = userDefaults
    }

    public subscript<T>(
        object key: Key
    ) -> T? {
        get { userDefaults.object(forKey: key.cacheEncoded()) as? T }
        set {
            guard let object = newValue else {
                remove(for: key)
                return
            }

            userDefaults.set(
                object,
                forKey: key.cacheEncoded()
            )
            userDefaults.synchronize()
        }
    }

    public subscript<T: JSONModel>(
        model key: Key
    ) -> T? {
        get {
            guard let data: Data = self[object: key] else {
                return nil
            }

            return try? T.decoded(data)
        }
        set {
            guard
                let model = newValue,
                let data = try? model.encoded()
            else {
                remove(for: key)
                return
            }

            self[object: key] = data
        }
    }

    public func remove(
        for key: Key
    ) {
        userDefaults.removeObject(forKey: key.cacheEncoded())
        userDefaults.synchronize()
    }
}
