// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol Application: AnyObject, AppLaunchable {
    associatedtype SomeAppTarget: AppTargetConvertible
    associatedtype SomeRouter: Router

    var target: SomeAppTarget { get }
    var router: SomeRouter { get }

    static var shared: Self { get }
}
