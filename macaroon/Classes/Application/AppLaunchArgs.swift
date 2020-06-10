// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AppLaunchArgs {
    associatedtype SomeScreenLaunchArgs: ScreenLaunchArgs

    func formScreenLaunchArgs(_ args: SomeScreenLaunchArgs.Options) -> SomeScreenLaunchArgs
    func invalidate()
}

public protocol AppLaunchable {
    associatedtype SomeAppLaunchArgs: AppLaunchArgs

    var appLaunchArgs: SomeAppLaunchArgs { get }
}
