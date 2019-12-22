// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ScreenLaunchable {
    associatedtype SomeScreenLaunchArgs: ScreenLaunchArgsConvertible

    var launchArgs: SomeScreenLaunchArgs { get }
}

public protocol ScreenLaunchArgsConvertible {
    associatedtype Options: OptionSet
}
