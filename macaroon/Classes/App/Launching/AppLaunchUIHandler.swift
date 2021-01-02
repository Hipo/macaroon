// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AppLaunchUIHandler: AnyObject {
    associatedtype SomeAppLaunchUIState: AppLaunchUIState

    func launchUI(_ state: SomeAppLaunchUIState)
}

public protocol AppLaunchUIState {
    static var readyToUse: Self { get }
}

/// <mark> Auth
public protocol AppAuthLaunchUIHandler: AppLaunchUIHandler
where SomeAppLaunchUIState: AppAuthLaunchUIState { }

public protocol AppAuthLaunchUIState: AppLaunchUIState {
    static var authRequired: Self { get }
}
