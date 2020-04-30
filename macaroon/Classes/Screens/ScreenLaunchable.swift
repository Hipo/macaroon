// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ScreenLaunchable: UIViewController {
    associatedtype SomeScreenLaunchArgs: ScreenLaunchArgs

    var launchArgs: SomeScreenLaunchArgs { get }
}

public protocol ScreenLaunchArgs {
    associatedtype Options: OptionSet
}
