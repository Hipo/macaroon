// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol RootContainer: UIViewController, AppLaunchable, AppLaunchControllerListener {
    associatedtype SomeAppLaunchController: AppLaunchController
    associatedtype SomeAppRouter: AppRouter

    var launchController: SomeAppLaunchController { get }
    var router: SomeAppRouter { get }

    init(
        launchController: SomeAppLaunchController,
        router: SomeAppRouter
    )
}

extension RootContainer {
    public var appLaunchArgs: SomeAppLaunchController.SomeAppLaunchArgs {
        return launchController.appLaunchArgs
    }
}

open class BaseRootContainer<SomeAppLaunchController: AppLaunchController, SomeAppRouter: AppRouter>: UIViewController, RootContainer {
    public var splash: UIViewController?
    public var authorizationContainer: UIViewController?
    public var homeContainer: UIViewController?

    public var isLaunched = false

    public var isAuthorizationFlowInProgress: Bool {
        return
            authorizationContainer != nil &&
            (authorizationContainer == presentedViewController ||
             authorizationContainer?.navigationController == presentedViewController)
    }
    public var isHomeFlowInProgress: Bool {
        return homeContainer?.parent != nil
    }

    public let launchController: SomeAppLaunchController
    public let router: SomeAppRouter

    public required init(
        launchController: SomeAppLaunchController,
        router: SomeAppRouter
    ) {
        self.launchController = launchController
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func showSplash() {
        if splash != nil {
            hideSplash()
        }
        let newSplash = router.makeSplash()
        fitToContainer(newSplash)
        splash = newSplash
    }

    open func hideSplash() {
        splash?.removeFromContainer()
        splash = nil
    }

    open func startAuthorizationFlow() {
        if isHomeFlowInProgress {
            if presentedViewController == nil {
                openAuthorizationFlow(isFirst: false)
            } else {
                dismiss(animated: false) { [unowned self] in
                    self.openAuthorizationFlow(isFirst: false)
                }
            }
            return
        }
        if isAuthorizationFlowInProgress {
            startOverAuthorizationFlow()
            return
        }
        openAuthorizationFlow(isFirst: true)
    }

    open func startOverAuthorizationFlow() {
        if let authorizationNavigationContainer = authorizationContainer as? NavigationContainer {
            authorizationNavigationContainer.popToRoot(animated: true)
        }
    }

    open func openAuthorizationFlow(isFirst: Bool) {
        if isFirst {
            authorizationContainer = router.openAuthorizationFlow(by: .presentation(.modal(.fullScreen)), animated: false, onCompleted: nil)
        } else {
            authorizationContainer = router.openAuthorizationFlow(by: .presentation(.modal(.fullScreen)), animated: true) { [unowned self] in
                self.endHomeFlow()
            }
        }
        asyncMainAfter(0.2) {
            self.hideSplash()
        }
    }

    open func endAuthorizationFlow() {
        if isAuthorizationFlowInProgress {
            dismiss(animated: true)
        }
    }

    open func startHomeFlow() {
        homeContainer = router.openHomeFlow(animated: false) { [unowned self] in
            self.hideSplash()
        }
        endAuthorizationFlow()
    }

    open func startHomeFlowIfNeeded() {
        if !isHomeFlowInProgress {
            startHomeFlow()
        }
    }

    open func endHomeFlow() {
        homeContainer?.removeFromContainer()
        homeContainer = nil
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        showSplash()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isLaunched {
            launchController.listener = self
            launchController.firstLaunch()
            isLaunched = true
        }
    }

    /// <mark> AppLaunchControllerListener
    open func launchControllerDidStart<T: AppLaunchController>(_ launchController: T) {
        startAuthorizationFlow()
    }

    open func launchControllerDidSignUp<T: AppLaunchController>(_ launchController: T) {
        startHomeFlow()
    }

    open func launchControllerDidSignIn<T: AppLaunchController>(_ launchController: T) {
        startHomeFlow()
    }

    open func launchControllerWillReauthenticate<T: AppLaunchController>(_ launchController: T) { }

    open func launchControllerDidReauthenticate<T: AppLaunchController>(_ launchController: T) {
        startHomeFlowIfNeeded()
    }

    open func launchControllerWillDeauthenticate<T: AppLaunchController>(_ launchController: T) {
        startAuthorizationFlow()
    }

    open func launchControllerDidDeauthenticate<T: AppLaunchController>(_ launchController: T) { }
}
