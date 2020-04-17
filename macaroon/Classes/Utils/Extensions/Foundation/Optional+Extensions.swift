// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension Optional {
    public func next<T>(either transform: (Wrapped) -> T, or someValue: T?) -> T? {
        return map(transform) ?? someValue
    }

    public func next<T>(either transform: (Wrapped) -> T, or someValue: T) -> T {
        return map(transform) ?? someValue
    }
}
