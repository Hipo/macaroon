// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ScreenLaunchable: UIViewController {
    associatedtype SomeScreenLaunchArgs: ScreenLaunchArgsConvertible

    var launchArgs: SomeScreenLaunchArgs { get }
}

public protocol ScreenLaunchArgsConvertible {
    associatedtype Options: OptionSet
}

public struct NoScreenLaunchArgs: ScreenLaunchArgsConvertible {
    public struct Options: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}
