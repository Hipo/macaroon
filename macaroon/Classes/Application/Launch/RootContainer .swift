// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol RootContainer: UIViewController {
    associatedtype SomeLaunchController: LaunchController

    var launchController: SomeLaunchController { get }
}
