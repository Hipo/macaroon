// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ViewModelConvertible {
    init<T>(_ model: T)
    mutating func bind<T>(_ model: T)
}
