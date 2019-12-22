// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AppLaunchable {
    associatedtype SomeAppLaunchArgs: AppLaunchArgsConvertible

    var appLaunchArgs: SomeAppLaunchArgs { get }
}

public protocol AppLaunchArgsConvertible {
    associatedtype SomeScreenLaunchArgs: ScreenLaunchArgsConvertible

    func formScreenLaunchArgs(_ args: SomeScreenLaunchArgs.Options) -> SomeScreenLaunchArgs
}
