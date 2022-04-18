// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AppLaunchUIHandler: AnyObject {
    associatedtype SomeAppLaunchUIState: AppLaunchUIState

    func launchUI(_ state: SomeAppLaunchUIState)
}

public protocol AppLaunchUIState {
    static var main: Self { get }
}
