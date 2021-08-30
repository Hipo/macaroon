// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AppLaunchUIController: AppLaunchController {
    associatedtype SomeAppLaunchUIHandler: AppLaunchUIHandler

    var uiHandler: SomeAppLaunchUIHandler { get }
}
