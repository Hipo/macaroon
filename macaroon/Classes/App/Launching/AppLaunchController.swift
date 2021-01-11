// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol AppLaunchController: AppLaunchControlling {
    associatedtype SomeAppLaunchUIHandler: AppLaunchUIHandler

    var uiHandler: SomeAppLaunchUIHandler { get }
}

public protocol AppLaunchControlling: AnyObject {
    func launch()
    func enterForeground()
    func becomeActive()
    func resignActive()
    func enterBackground()
}

extension AppLaunchControlling {
    public func enterForeground() { }
    public func becomeActive() { }
    public func resignActive() { }
    public func enterBackground() { }
}

/// <mark> Auth
public protocol AppAuthLaunchController: AppLaunchController, AppAuthLaunchControlling
where SomeAppLaunchUIHandler: AppAuthLaunchUIHandler { }

public protocol AppAuthLaunchControlling: AppLaunchControlling {
    func signIn(onCompleted execute: @escaping (Swift.Error?) -> Void)
    func signUp(onCompleted execute: @escaping (Swift.Error?) -> Void)
}
