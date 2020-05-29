// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class AuthenticationRootContainer<SomeLaunchController: AuthenticationLaunchController, SomeRouter: Router>: UIViewController, RootContainerConvertible, AuthenticationLaunchControllerDelegate {
    public var isLaunched = false

    public var splash: UIViewController?
    public weak var authorizationContainer: UIViewController?
    public weak var mainContainer: UIViewController?

    override open var childForStatusBarHidden: UIViewController? {
        return mainContainer
    }
    override open var childForStatusBarStyle: UIViewController? {
        return mainContainer
    }

    public let launchController: SomeLaunchController
    public let router: SomeRouter

    public init(
        launchController: SomeLaunchController,
        router: SomeRouter
    ) {
        self.launchController = launchController
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func splashWillOpen() { }
    open func splashDidOpen() { }
    open func splashWillClose() { }
    open func splashDidClose() { }

    open func authorizationFlowWillStart() { }
    open func authorizationFlowDidStart() { }
    open func authorizationFlowWillEnd() { }
    open func authorizationFlowDidEnd() { }

    open func mainFlowWillStart() { }
    open func mainFlowDidStart() { }
    open func mainFlowWillEnd() { }
    open func mainFlowDidEnd() { }

    open override func viewDidLoad() {
        super.viewDidLoad()
        openSplash()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isLaunched {
            launchController.delegate = self
            launchController.firstLaunch()
            isLaunched = true
        }
    }

    /// <mark> AuthenticationLaunchControllerDelegate
    open func launchControllerDidStart<T: LaunchController>(_ launchController: T) {
        startAuthorizationFlow()
    }

    open func launchControllerDidSignUp<T: LaunchController>(_ launchController: T) {
        startMainFlow()
    }

    open func launchControllerDidSignIn<T: LaunchController>(_ launchController: T) {
        startMainFlow()
    }

    open func launchControllerWillReauthenticate<T: LaunchController>(_ launchController: T) { }

    open func launchControllerDidReauthenticate<T: LaunchController>(_ launchController: T) {
        startMainFlow(force: false)
    }

    open func launchControllerWillDeauthenticate<T: LaunchController>(_ launchController: T) {
        startAuthorizationFlow()
    }

    open func launchControllerDidDeauthenticate<T: LaunchController>(_ launchController: T) { }
}

extension AuthenticationRootContainer {
    public func openSplash() {
        splashWillOpen()

        if let splash = splash {
            view.bringSubviewToFront(splash.view)
        } else {
            splash = fitInContent(router.makeSplash())
        }

        splashDidOpen()
    }

    public func closeSplash() {
        splashWillClose()

        splash?.removeFromContainer()
        splash = nil

        splashDidClose()
    }
}

extension AuthenticationRootContainer {
    public func startAuthorizationFlow() {
        authorizationFlowWillStart()

        if router.hasStartedMainFlow() {
            continueAfterDismiss(animated: false) { [unowned self] in
                self.authorizationContainer = self.router.startAuthorizationFlow(isFirst: false) { [unowned self] in
                    self.closeSplash()
                    self.endMainFlow()

                    self.authorizationFlowDidStart()
                }
            }
        } else {
            self.authorizationContainer = router.startAuthorizationFlow(isFirst: true) { [unowned self] in
                self.closeSplash()

                self.authorizationFlowDidStart()
            }
        }
    }

    public func endAuthorizationFlow() {
        authorizationFlowWillEnd()

        router.endAuthorizationFlow { [unowned self] in
            self.authorizationContainer = nil

            self.authorizationFlowDidEnd()
        }
    }
}

extension AuthenticationRootContainer {
    public func startMainFlow(force: Bool = true) {
        mainFlowWillStart()

        if router.hasStartedMainFlow() && !force {
            mainFlowDidStart()
            return
        }
        mainContainer = router.startMainFlow(force: force) { [unowned self] in
            self.closeSplash()
            self.endAuthorizationFlow()

            self.mainFlowDidStart()
        }
        setNeedsStatusBarAppearanceUpdate()
    }

    public func endMainFlow() {
        mainFlowWillEnd()

        router.endMainFlow { [unowned self] in
            self.mainContainer = nil
            self.mainFlowDidEnd()
        }
    }
}

public protocol RootContainerConvertible: UIViewController, AppLaunchable {
    associatedtype SomeLaunchController: LaunchController
    associatedtype SomeRouter: Router

    var launchController: SomeLaunchController { get }
    var router: SomeRouter { get }
}

extension RootContainerConvertible {
    public var appLaunchArgs: SomeLaunchController.SomeAppLaunchArgs {
        return launchController.appLaunchArgs
    }
}
