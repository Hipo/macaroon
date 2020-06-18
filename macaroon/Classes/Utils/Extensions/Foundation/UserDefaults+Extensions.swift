// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension UserDefaults {
    public func set(_ object: Any, for key: String) {
        set(object, forKey: key)
    }
    
    public func remove(for key: String) {
        removeObject(forKey: key)
    }
    
    public func clear() {
        let defaultsDictionary = dictionaryRepresentation()
        
        defaultsDictionary.keys.forEach { key in
            removeObject(forKey: key)
        }
    }
}
