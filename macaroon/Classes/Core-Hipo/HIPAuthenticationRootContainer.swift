// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class HIPAuthenticationRootContainer<SomeAuthenticationLaunchController: AuthenticationLaunchController, SomeRouter: Router>: UIViewController, RootContainer, AuthenticationLaunchControllerDelegate {
    public weak var splash: UIViewController?
    public weak var authenticationContainer: UIViewController?
    public weak var mainContainer: UIViewController?

    override open var childForStatusBarHidden: UIViewController? {
        return authenticationContainer ?? mainContainer
    }
    override open var childForStatusBarStyle: UIViewController? {
        return authenticationContainer ?? mainContainer
    }

    public let launchController: SomeAuthenticationLaunchController
    public let router: SomeRouter

    private let onceWhenViewDidAppear = Once()

    public init(
        launchController: SomeAuthenticationLaunchController,
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

    open func openSplash() {
        if let splash = splash {
            view.bringSubviewToFront(splash.view)
        } else {
            splash = fitInContent(router.makeSplash())
        }
        splashDidOpen()
    }

    open func splashDidOpen() { }

    open func closeSplash() {
        splash?.removeFromContainer()
        splash = nil
        splashDidClose()
    }

    open func splashDidClose() { }

    open func startAuthenticationFlow() {
        func startAuthenticationFlowImmediately() {
            authenticationContainer = router.startAuthenticationFlow(first: !router.hasStartedMainFlow()) { [unowned self] in
                self.closeSplash()
                self.endMainFlow()
                self.authenticationFlowDidStart()
            }
        }
        if router.hasStartedMainFlow() {
            dismissIfPresent(animated: false, completion: startAuthenticationFlowImmediately)
        } else {
            startAuthenticationFlowImmediately()
        }
    }

    open func authenticationFlowDidStart() {
        setNeedsStatusBarAppearanceUpdate()
    }

    open func endAuthenticationFlow() {
        router.endAuthenticationFlow { [unowned self] in
            self.authenticationContainer = nil
            self.authenticationFlowDidEnd()
        }
    }

    open func authenticationFlowDidEnd() { }

    open func startMainFlow(force: Bool) {
        if !force && router.hasStartedMainFlow() {
            mainFlowDidStart()
            return
        }
        mainContainer = router.startMainFlow(force: force) { [unowned self] in
            self.closeSplash()
            self.endAuthenticationFlow()
            self.mainFlowDidStart()
        }
    }

    open func mainFlowDidStart() {
        setNeedsStatusBarAppearanceUpdate()
    }

    open func endMainFlow() {
        router.endMainFlow { [unowned self] in
            self.mainContainer = nil
            self.mainFlowDidEnd()
        }
    }

    open func mainFlowDidEnd() { }

    open override func viewDidLoad() {
        super.viewDidLoad()
        openSplash()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        onceWhenViewDidAppear.execute {
            launchController.delegate = self
            launchController.firstLaunch()
        }
    }

    /// <mark> AuthenticationLaunchControllerDelegate
    open func launchControllerDidFirstLaunch(_ launchController: AuthenticationLaunchController) {
        startAuthenticationFlow()
    }

    open func launchControllerDidSignUp(_ launchController: AuthenticationLaunchController) {
        startMainFlow(force: true)
    }

    open func launchControllerDidSignIn(_ launchController: AuthenticationLaunchController) {
        startMainFlow(force: true)
    }

    open func launchControllerDidSignInAutomatically(_ launchController: AuthenticationLaunchController) {
        startMainFlow(force: false)
    }

    open func launchControllerDidSignOut(_ launchController: AuthenticationLaunchController) {
        startAuthenticationFlow()
    }
}
