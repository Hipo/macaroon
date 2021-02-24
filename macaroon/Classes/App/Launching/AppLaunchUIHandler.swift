// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AppLaunchUIHandler: AnyObject {
    associatedtype SomeAppLaunchUIState: AppLaunchUIState

    func launchUI(_ state: SomeAppLaunchUIState, firstTime: Bool)
}

public protocol AppLaunchUIState {
    associatedtype MainScreen: UIViewController

    static func main(completion: ((MainScreen) -> Void)?) -> Self
}

/// <mark>
/// Auth
public protocol AppAuthLaunchUIHandler: AppLaunchUIHandler
where SomeAppLaunchUIState: AppAuthLaunchUIState { }

public protocol AppAuthLaunchUIState: AppLaunchUIState {
    associatedtype OnboardingScreen: UIViewController

    static func onboarding(completion: ((OnboardingScreen) -> Void)?) -> Self
}
