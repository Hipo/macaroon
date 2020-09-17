// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class Screen: UIViewController, ScreenComposable, StatusBarConfigurable, NavigationBarConfigurable, UIAdaptivePresentationControllerDelegate, NotificationObserver {
    public var isStatusBarHidden = false
    public var hidesStatusBarOnAppeared = false
    public var hidesStatusBarOnPresented = false

    public var isNavigationBarHidden = false
    public var hidesCloseBarItem = false
    public var hidesDismissBarItemIniOS13AndLater = false
    public var disablesInteractivePopGesture = false

    public var leftBarItems: [NavigationBarItemConvertible] = []
    public var rightBarItems: [NavigationBarItemConvertible] = []

    public var disablesInteractiveDismiss = false {
        didSet {
            if #available(iOS 13.0, *) {
                isModalInPresentation = disablesInteractiveDismiss
            }
        }
    }

    public var observations: [NSObjectProtocol] = []

    public private(set) var isViewFirstAppeared = true
    public private(set) var isViewAppearing = false
    public private(set) var isViewAppeared = false
    public private(set) var isViewDisappearing = false
    public private(set) var isViewDisappeared = false
    public private(set) var isViewDismissed = false
    public private(set) var isViewPopped = false

    open override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return isStatusBarHidden ? .fade : .none
    }

    public init() {
        super.init(nibName: nil, bundle: nil)

        disablesInteractivePopGesture = isNavigationBarHidden || hidesCloseBarItem

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

    public func observeApplicationLifeCycleNotifications() {
        notifyWhenApplicationWillEnterForeground { [unowned self] _ in
            self.viewWillEnterForeground()
        }
        notifyWhenApplicationDidEnterBackground { [unowned self] _ in
            self.viewDidEnterBackground()
        }
    }

    open func customizeNavigationBarAppearance() {
        customizeNavigationBarTitleAppearance()
        customizeNavigationBarLeftBarItems()
        customizeNavigationBarRightBarItems()
    }

    open func customizeNavigationBarTitleAppearance() { }
    open func customizeNavigationBarLeftBarItems() { }
    open func customizeNavigationBarRightBarItems() { }

    open func makeDismissNavigationBarItem() -> NavigationBarItemConvertible {
        mc_crash(.dismissNavigationBarItemNotFound)
    }

    open func makePopNavigationBarItem() -> NavigationBarItemConvertible {
        mc_crash(.popNavigationBarItemNotFound)
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

    open func viewDidAttemptInteractiveDismiss() { }

    open func viewDidAppearAfterInteractiveDismiss() {
        isViewFirstAppeared = false
        (parent as? Screen)?.viewDidAppearAfterInteractiveDismiss()
    }

    open func viewWillEnterForeground() { }

    open func viewDidEnterBackground() {
        if isViewAppeared {
            isViewFirstAppeared = false
        }
    }

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

    /// <mark> UIAdaptivePresentationControllerDelegate
    open func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewDidAppearAfterInteractiveDismiss()
    }

    open func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let presentingScreen =
            (presentationController.presentingViewController as? UINavigationController)?.viewControllers.last ??
            presentationController.presentingViewController
        (presentingScreen as? Screen)?.viewDidAttemptInteractiveDismiss()
    }
}
