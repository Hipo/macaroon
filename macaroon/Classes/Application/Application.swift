// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol Application: AnyObject, AppLaunchable {
    associatedtype SomeAppTarget: AppTargetConvertible
    associatedtype SomeAppRouter: AppRouter

    var target: SomeAppTarget { get }
    var router: SomeAppRouter { get }

    static var shared: Self { get }
}
