// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol RootContainer: UIViewController {
    associatedtype SomeLaunchController: LaunchController
    associatedtype SomeRouter: Router

    var launchController: SomeLaunchController { get }
    var router: SomeRouter { get }
}
