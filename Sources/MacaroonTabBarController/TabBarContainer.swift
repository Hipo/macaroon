// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

open class TabBarContainer:
    Screen,
    TabbedContainer {
    open override var childForStatusBarHidden: UIViewController? {
        return selectedScreen
    }
    open override var childForStatusBarStyle: UIViewController? {
        return selectedScreen
    }

    public var items: [TabBarItem] = [] {
        didSet { updateLayoutWhenItemsDidChange() }
    }
    public var selectedIndex: Int? {
        willSet {
            if selectedIndex == newValue {
                return
            }

            updateLayoutBeforeSelectedTabWillChange()
        }
        didSet {
            if selectedIndex == oldValue {
                return
            }

            tabBar.selectedIndex = selectedIndex

            updateLayoutAfterSelectedTabDidChange()
            selectedIndexDidChange()
        }
    }

    public var screens: [UIViewController] = []
    public var selectedScreen: UIViewController? {
        get {
            selectedIndex.unwrap {
                return items[safe: $0]?.screen
            }
        }
        set {
            selectedIndex =
                newValue.unwrap {
                    selectedScreen in

                    items.firstIndex {
                        $0.screen == selectedScreen
                    }
                }
        }
    }

    public private(set) lazy var tabBar = TabBar()
    public private(set) var isTabBarHidden = false

    public init() {
        super.init(
            configurator: nil
        )

        self.flowIdentifier = "main"
        self.pathIdentifier = "mainContainer"
    }

    open func addTabBar() {
        view.addSubview(
            tabBar
        )
        tabBar.snp.makeConstraints {
            $0.setPaddings(
                (.noMetric, 0, 0, 0)
            )
        }
    }

    open func updateLayoutWhenItemsDidChange() {
        if !isViewLoaded {
            return
        }

        selectedIndex = nil

        tabBar.items = items
        screens =
            items.compactMap {
                $0.screen
            }

        if items.isEmpty {
            return
        }

        selectedIndex = items.startIndex
    }

    open func updateLayoutBeforeSelectedTabWillChange() {
        hideSelectedTab()
    }

    open func updateLayoutAfterSelectedTabDidChange() {
        showSelectedTab()
        adjustSelectedTabSafeAreaOnAppeared()
    }

    open func selectedIndexDidChange() {}

    open override func prepareLayout() {
        super.prepareLayout()

        addTabBar()
        updateLayoutWhenItemsDidChange()
    }

    open override func setListeners() {
        tabBar.barButtonDidSelect = {
            [unowned self] index in

            self.selectedIndex = index
        }
    }

    open override func viewDidAppear(
        _ animated: Bool
    ) {
        super.viewDidAppear(
            animated
        )

        adjustSelectedTabSafeAreaOnAppeared()
    }
}

extension TabBarContainer {
    public func setTabBarHidden(
        _ isHidden: Bool,
        animated: Bool
    ) {
        if isHidden == isTabBarHidden {
            return
        }

        tabBar.snp.updateConstraints {
            $0.bottom == (isHidden ? -tabBar.bounds.height : 0.0)
        }

        let completion = {
            [weak self] in

            guard let self = self else {
                return
            }

            self.isTabBarHidden = isHidden
            self.adjustSelectedTabSafeAreaOnAppeared()
        }

        if !animated ||
           !isViewAppeared {
            completion()
            return
        }

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                [unowned self] in

                self.view.layoutIfNeeded()
            },
            completion: {
                _ in

                completion()
            }
        )
    }

    public func set(
        badge: String?,
        forItemAt index: Int,
        animated: Bool
    ) {
        tabBar.set(
            badge: badge,
            forBarButtonAt: index,
            animated: animated
        )
    }
}

extension TabBarContainer {
    public func showSelectedTab() {
        guard let selectedScreen = selectedScreen else {
            return
        }

        addFragment(
            selectedScreen
        ) { [unowned self] screenView in
            view.insertSubview(
                screenView,
                belowSubview: tabBar
            )
            screenView.snp.makeConstraints {
                $0.setPaddings()
            }
        }
    }

    public func hideSelectedTab() {
        guard let selectedScreen = selectedScreen else {
            return
        }

        removeFragment(
            selectedScreen
        )
    }
}

extension TabBarContainer {
    public func adjustSelectedTabSafeAreaOnAppeared() {
        if !isViewAppeared {
            return
        }

        guard let selectedScreen = selectedScreen else {
            return
        }

        var newAdditionalSafeAreaInsets = selectedScreen.additionalSafeAreaInsets
        newAdditionalSafeAreaInsets.bottom =
            isTabBarHidden ? 0 : tabBar.bounds.height - view.compactSafeAreaInsets.bottom 
        selectedScreen.additionalSafeAreaInsets = newAdditionalSafeAreaInsets
    }
}
