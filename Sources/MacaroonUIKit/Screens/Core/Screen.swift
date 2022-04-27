// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

open class Screen:
    UIViewController,
    ScreenComposable,
    ScreenRoutable,
    NotificationObserver,
    TabBarControlling,
    StatusBarControlling,
    UIAdaptivePresentationControllerDelegate {

    public var notificationObservations: [NSObjectProtocol] = []

    public var flowIdentifier: String = ""
    public var pathIdentifier: String = ""

    public private(set) var isViewFirstAppeared = true
    public private(set) var isViewAppearing = false
    public private(set) var isViewAppeared = false
    public private(set) var isViewDisappearing = false
    public private(set) var isViewDisappeared = false
    public private(set) var isViewDismissed = false
    public private(set) var isViewPopped = false
    
    public let statusBarController = StatusBarController()
    public let navigationBarController = NavigationBarController()
    public let tabbarController = TabBarController()

    open override var prefersStatusBarHidden: Bool {
        return statusBarController.isStatusBarHidden
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return statusBarController.isStatusBarHidden ? .fade : .none
    }

    private var lifeCycleObservers: Set<AnyScreenLifeCycleObserver> = []

    public init() {
        super.init(
            nibName: nil,
            bundle: nil
        )

        navigationBarController.screen = self
        tabbarController.screen = self

        configureStatusBar()
        configureNavigationBar()
        configureTabBar()
        observeNotifications()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        unobserveNotifications()
    }

    open func configureNavigationBar() {}
    
    open func configureTabBar() {}
    
    open func configureStatusBar() {}

    open func observeNotifications() {}

    public func observeApplicationLifeCycleNotifications() {
        observeWhenApplicationWillEnterForeground {
            [unowned self] _ in

            self.viewWillEnterForeground()
        }
        observeWhenApplicationDidEnterBackground {
            [unowned self] _ in

            self.viewDidEnterBackground()
        }
    }

    open func customizeAppearance() {}

    open func customizeViewAppearance(
        _ style: ViewStyle
    ) {
        view.customizeAppearance(
            style
        )
        navigationController?.view.customizeAppearance(
            style
        )
    }

    open func prepareLayout() {}
    open func updateLayoutWhenViewDidLayoutSubviews() {}

    open func setListeners() {}
    open func linkInteractors() {}

    open func bindData() {}

    open func viewDidAttemptInteractiveDismiss() {
        notifyObservers {
            $0.viewDidAttempInteractiveDismiss(self)
        }
    }

    open func viewDidAppearAfterInteractiveDismiss() {
        isViewFirstAppeared = false

        if let parentScreen = parent as? Screen {
            parentScreen.viewDidAppearAfterInteractiveDismiss()
        }

        notifyObservers {
            $0.viewDidAppearAfterInteractiveDismiss(self)
        }
    }

    /// <note>
    /// It is expected to be called when the screen is dismissed programmatically since the
    /// custom-presented screens doesn't call `viewWillAppear(_:)` or `viewDidAppear(_:)`. Router
    /// mechanism will handle it automatically but for other case it should be triggerred manually.
    open func viewDidAppearAfterDismiss() {
        isViewFirstAppeared = false

        if let parentScreen = parent as? Screen {
            parentScreen.viewDidAppearAfterDismiss()
        }

        notifyObservers {
            $0.viewDidAppearAfterDismiss(self)
        }
    }

    open func viewDidChangePreferredUserInterfaceStyle() {
        notifyObservers {
            $0.viewDidChangePreferredUserInterfaceStyle(self)
        }
    }

    open func viewDidChangePreferredContentSizeCategory() {
        notifyObservers {
            $0.viewDidChangePreferredContentSizeCategory(self)
        }
    }

    open func viewWillEnterForeground() {
        notifyObservers {
            $0.viewWillEnterForeground(self)
        }
    }

    open func viewDidEnterBackground() {
        if isViewAppeared {
            isViewFirstAppeared = false
        }

        notifyObservers {
            $0.viewDidEnterBackground(self)
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        compose()

        notifyObservers {
            $0.viewDidLoad(self)
        }
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayoutWhenViewDidLayoutSubviews()

        notifyObservers {
            $0.viewDidLayoutSubviews(self)
        }
    }

    open override func viewWillAppear(
        _ animated: Bool
    ) {
        super.viewWillAppear(
            animated
        )

        if isViewFirstAppeared {
            notifyObservers {
                $0.viewDidFirstAppear(self)
            }
        }

        isViewDisappearing = false
        isViewDisappeared = false
        isViewAppearing = true

        notifyObservers {
            $0.viewWillAppear(self)
        }
    }

    open override func viewDidAppear(
        _ animated: Bool
    ) {
        super.viewDidAppear(
            animated
        )

        isViewAppearing = false
        isViewAppeared = true

        notifyObservers {
            $0.viewDidAppear(self)
        }
    }

    open override func viewWillDisappear(
        _ animated: Bool
    ) {
        super.viewWillDisappear(animated)

        isViewFirstAppeared = false
        isViewAppeared = false
        isViewDisappearing = true
        isViewDismissed = isBeingDismissed
        isViewPopped = isMovingFromParent

        notifyObservers {
            $0.viewWillDisappear(self)
        }
    }

    open override func viewDidDisappear(
        _ animated: Bool
    ) {
        super.viewDidDisappear(
            animated
        )

        isViewDisappearing = false
        isViewDisappeared = true

        notifyObservers {
            $0.viewDidDisappear(self)
        }
    }

    open override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        super.traitCollectionDidChange(
            previousTraitCollection
        )

        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                viewDidChangePreferredUserInterfaceStyle()
            }
        }

        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            viewDidChangePreferredContentSizeCategory()
        }
    }

    /// <mark>
    /// UIAdaptivePresentationControllerDelegate
    open func presentationControllerDidDismiss(
        _ presentationController: UIPresentationController
    ) {
        viewDidAppearAfterInteractiveDismiss()
    }

    open func presentationControllerDidAttemptToDismiss(
        _ presentationController: UIPresentationController
    ) {
        guard var presentingScreen = presentingViewController else {
            return
        }

        if let presentingNavigationContainer = presentingScreen as? UINavigationController,
           let presentingNavigationScreen = presentingNavigationContainer.viewControllers.last {
            presentingScreen = presentingNavigationScreen
        }

        guard let configurablePresentingScreen = presentingScreen as? Screen else {
            return
        }

        configurablePresentingScreen.viewDidAttemptInteractiveDismiss()
    }
}

/// <mark>
/// ScreenLifeCyclePublisher
extension Screen {
    public func add<T: ScreenLifeCycleObserver>(
        lifeCycleObserver: T
    ) {
        let observer = AnyScreenLifeCycleObserver(lifeCycleObserver)
        lifeCycleObservers.insert(observer)
    }

    public func remove<T: ScreenLifeCycleObserver>(
        lifeCycleObserver: T
    ) {
        let observer = AnyScreenLifeCycleObserver(lifeCycleObserver)
        lifeCycleObservers.remove(observer)
    }

    public func invalidateLifeCycleObservers() {
        lifeCycleObservers.removeAll()
    }

    private func notifyObservers(
        _ block: (AnyScreenLifeCycleObserver) -> Void
    ) {
        lifeCycleObservers.forEach {
            block($0)
        }
    }
}
