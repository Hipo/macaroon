// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ViewModelConvertible {
    init<T>(_ model: T)
    func bind<T>(_ model: T)
}

public struct NoViewModel: ViewModelConvertible {
    public init<T>(_ model: T) { }
    public func bind<T>(_ model: T) { }
}
