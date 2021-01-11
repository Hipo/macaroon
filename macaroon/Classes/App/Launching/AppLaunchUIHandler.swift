// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AppLaunchUIHandler: AnyObject {
    associatedtype SomeAppLaunchUIState: AppLaunchUIState

    func launchUI(_ state: SomeAppLaunchUIState, first: Bool)
}

public protocol AppLaunchUIState {
    associatedtype MainScreen: UIViewController

    static func readyToUse(completion: @escaping (MainScreen) -> Void) -> Self
}

/// <mark> Auth
public protocol AppAuthLaunchUIHandler: AppLaunchUIHandler
where SomeAppLaunchUIState: AppAuthLaunchUIState { }

public protocol AppAuthLaunchUIState: AppLaunchUIState {
    static var authRequired: Self { get }
}
