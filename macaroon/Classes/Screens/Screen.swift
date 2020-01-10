// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class Screen<SomeScreenLaunchArgs: ScreenLaunchArgsConvertible, SomeAppRouter: AppRouter>: UIViewController, ScreenLaunchable, ScreenComposable, ScreenRoutable, StatusBarConfigurable, NavigationBarConfigurable, NotificationObserver {
    public var isStatusBarHidden = false
    public var hidesStatusBarOnAppeared = false
    public var hidesStatusBarOnPresented = false

    public var isNavigationBarHidden = false
    public var hidesCloseBarButtonItem = false
    public var leftBarButtonItems: [NavigationBarButtonItemConvertible] = []
    public var rightBarButtonItems: [NavigationBarButtonItemConvertible] = []

    public var observations: [NSObjectProtocol] = []

    public private(set) var isViewFirstAppeared = true
    public private(set) var isViewAppearing = false
    public private(set) var isViewAppeared = false
    public private(set) var isViewDisappearing = false
    public private(set) var isViewDisappeared = false
    public private(set) var isViewDismissed = false
    public private(set) var isViewPopped = false

    open var router: SomeAppRouter {
        mc_crash(.routerNotFound)
    }

    open override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return isStatusBarHidden ? .fade : .none
    }

    public let launchArgs: SomeScreenLaunchArgs

    public init(launchArgs: SomeScreenLaunchArgs) {
        self.launchArgs = launchArgs

        super.init(nibName: nil, bundle: nil)

        customizeNavigationBarAppearance()
        observeNotifications()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        unobserveNotifications()
    }

    open func observeNotifications() { }

    open func customizeNavigationBarAppearance() {
        customizeNavigationBarTitleAppearance()
        customizeNavigationBarLeftBarButtonItems()
        customizeNavigationBarRightBarButtonItems()
    }

    open func customizeNavigationBarTitleAppearance() { }
    open func customizeNavigationBarLeftBarButtonItems() { }
    open func customizeNavigationBarRightBarButtonItems() { }

    open func makeDismissNavigationBarButtonItem() -> NavigationBarButtonItemConvertible {
        mc_crash(.dismissNavigationBarButtonItemNotFound)
    }

    open func makePopNavigationBarButtonItem() -> NavigationBarButtonItemConvertible {
        mc_crash(.popNavigationBarButtonItemNotFound)
    }

    open func canDismiss() -> Bool {
        return true
    }

    open func canPop() -> Bool {
        return true
    }

    open func customizeAppearance() {
        customizeViewAppearance()
    }

    open func customizeViewAppearance() { }

    open func prepareLayout() { }
    open func updateLayoutWhenViewDidLayoutSubviews() { }

    open func setListeners() { }
    open func linkInteractors() { }

    open func viewDidChangePreferredContentSizeCategory() { }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsNavigationBarAppearanceUpdate()
        compose()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayoutWhenViewDidLayoutSubviews()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNeedsStatusBarAppearanceUpdateOnAppearing()
        setNeedsNavigationBarAppearanceUpdateOnAppearing()

        isViewDisappearing = false
        isViewDisappeared = false
        isViewAppearing = true
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewAppearing = false
        isViewAppeared = true
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        setNeedsStatusBarAppearanceUpdateOnDisappearing()

        isViewFirstAppeared = false
        isViewAppeared = false
        isViewDisappearing = true
        isViewDismissed = isBeingDismissed
        isViewPopped = isMovingFromParent
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isViewDisappearing = false
        isViewDisappeared = true
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            viewDidChangePreferredContentSizeCategory()
        }
    }
}
