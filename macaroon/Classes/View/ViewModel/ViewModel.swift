// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ViewModel {
    init()
    func bind<T>(_ model: T)
}

extension ViewModel {
    public init<T>(model: T) {
        self.init()
        self.bind(model)
    }
}

public struct NoViewModel: ViewModel {
    public init() { }
    public func bind<T>(_ model: T) { }
}
