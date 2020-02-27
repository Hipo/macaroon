// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ViewModelConvertible {
    /// <todo> Can bind a nil model??? Maybe a reset() method.
    mutating func bind<T>(_ model: T)
}
