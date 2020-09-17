// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AppLaunchable {
    associatedtype SomeAppLaunchArgs: AppLaunchArgs

    var appLaunchArgs: SomeAppLaunchArgs { get }
}

public protocol AppLaunchArgs {
    associatedtype Options: OptionSet
    associatedtype SomeScreenLaunchArgs: ScreenLaunchArgs

    func formScreenLaunchArgs(_ args: Options) -> SomeScreenLaunchArgs
    func invalidate()
}
