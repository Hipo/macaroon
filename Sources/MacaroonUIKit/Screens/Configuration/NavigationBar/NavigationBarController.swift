// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

open class NavigationBarController: ScreenLifeCycleObserver {
    public var isNavigationBarHidden = false {
        didSet { navigationBarDidChangeVisibility() }
    }
    public var isBackButtonHidden = false {
        didSet { backButtonDidChangeVisibility() }
    }
    public var isBackButtonTitleHidden = true {
        didSet { backButtonDidChangeVisibility() }
    }
    public var isInteractivePopGestureEnabled: Bool {
        return !isNavigationBarHidden && !isBackButtonHidden
    }

    public var leftBarButtonItems: [NavigationBarButtonItem] = [] {
        didSet { leftBarButtonItemsDidChange() }
    }
    public var rightBarButtonItems: [NavigationBarButtonItem] = [] {
        didSet { rightBarButtonItemsDidChange() }
    }

    public var navigationController: UINavigationController? {
        let parentController = screen.parent

        return screen.navigationController.unwrap {
            $0 == parentController
        }
    }

    public weak var screen: Screen! {
        didSet { screen.add(lifeCycleObserver: self) }
    }

    public init() {}
}

extension NavigationBarController {
    public func setNeedsNavigationBarAppearanceUpdate() {
        guard
            let navigationController = screen.navigationController,
            navigationController.isNavigationBarHidden != isNavigationBarHidden
        else {
            return
        }

        let isAnimated =
            !(
                navigationController.isBeingPresented &&
                navigationController.isRoot(screen)
            )

        navigationController.setNavigationBarHidden(
            isNavigationBarHidden,
            animated: isAnimated
        )
    }

    public func setNeedsNavigationBarButtonItemsUpdate() {
        setNeedsNavigationBarBackButtonItemUpdate()
        setNeedsNavigationBarLeftBarButtonItemsUpdate()
        setNeedsNavigationBarRightBarButtonItemsUpdate()
    }

    public func setNeedsNavigationBarBackButtonItemUpdate() {
        screen.navigationItem.hidesBackButton = isBackButtonHidden

        if #available(iOS 14, *) {
            screen.navigationItem.backButtonDisplayMode =
                isBackButtonTitleHidden ? .minimal : .default
        } else {
            screen.navigationItem.backButtonTitle = isBackButtonTitleHidden ? "" : nil
        }
    }

    public func setNeedsNavigationBarLeftBarButtonItemsUpdate() {
        screen.navigationItem.leftItemsSupplementBackButton = true
        screen.navigationItem.leftBarButtonItems = mapBarButtonItems(from: leftBarButtonItems)
        finishBarButtonItemsUpdate()
    }

    public func setNeedsNavigationBarRightBarButtonItemsUpdate() {
        screen.navigationItem.rightBarButtonItems = mapBarButtonItems(from: rightBarButtonItems)
        finishBarButtonItemsUpdate()
    }
}

extension NavigationBarController {
    private func navigationBarDidChangeVisibility() {
        if !screen.isViewAppeared {
            return
        }

        setNeedsNavigationBarAppearanceUpdate()
    }

    private func backButtonDidChangeVisibility() {
        if !screen.isViewLoaded {
            return
        }

        setNeedsNavigationBarBackButtonItemUpdate()
    }

    private func leftBarButtonItemsDidChange() {
        if !screen.isViewLoaded {
            return
        }

        setNeedsNavigationBarLeftBarButtonItemsUpdate()
    }

    private func rightBarButtonItemsDidChange() {
        if !screen.isViewLoaded {
            return
        }

        setNeedsNavigationBarRightBarButtonItemsUpdate()
    }

    private func finishBarButtonItemsUpdate() {
        screen.navigationController?.navigationBar.layoutIfNeeded()
    }
}

extension NavigationBarController {
    private func mapBarButtonItems(
        from navigationBarButtonItems: [NavigationBarButtonItem]
    ) -> [UIBarButtonItem] {
        guard let navigationController = navigationController else {
            return []
        }

        return navigationBarButtonItems.compactMap {
            item in

            switch item {
            case let dismissItem as DismissNavigationBarButtonItem:
                if screen.presentingViewController == nil {
                    return nil
                }

                if dismissItem.isOnlyVisibleAtRoot &&
                   !navigationController.isRoot(screen) {
                    return nil
                }

                return dismissItem.asSystemBarButtonItem()
            default:
                return item.asSystemBarButtonItem()
            }
        }
    }
}

/// <mark>
/// ScreenLifeCycleListener
extension NavigationBarController {
    public func viewDidLoad(
        _ screen: Screen
    ) {
        setNeedsNavigationBarButtonItemsUpdate()
    }

    public func viewWillAppear(
        _ screen: Screen
    ) {
        setNeedsNavigationBarAppearanceUpdate()
    }
}

/// <mark>
/// Hashable
extension NavigationBarController {
    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(ObjectIdentifier(self))
    }

    public static func == (
        lhs: NavigationBarController,
        rhs: NavigationBarController
    ) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
