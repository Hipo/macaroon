// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AuthenticationLaunchController: LaunchController {
    var delegate: AuthenticationLaunchControllerDelegate? { get set }

    func continueAfterSignUp()
    func continueAfterSignIn()
    func continueAfterSignInAutomatically(first: Bool)
    func signoutAndRelaunch()
}

public protocol AuthenticationLaunchControllerDelegate: AnyObject {
    func launchControllerDidFirstLaunch(_ launchController: AuthenticationLaunchController)
    func launchControllerDidSignUp(_ launchController: AuthenticationLaunchController)
    func launchControllerDidSignIn(_ launchController: AuthenticationLaunchController)
    func launchControllerDidSignInAutomatically(_ launchController: AuthenticationLaunchController)
    func launchControllerDidSignOut(_ launchController: AuthenticationLaunchController)
}
