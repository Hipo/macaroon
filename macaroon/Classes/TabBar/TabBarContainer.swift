// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
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

            hideSelectedTab()
        }
        didSet {
            if selectedIndex == oldValue {
                return
            }

            tabBar.selectedIndex = selectedIndex

            showSelectedTab()

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
}

extension TabBarContainer {
    public func setTabBarHidden(
        _ isHidden: Bool,
        animated: Bool
    ) {
        let bottomPadding = isHidden ? -tabBar.bounds.height : 0.0

        if isViewAppeared {
            let currentBottomPadding = view.bounds.height - tabBar.frame.maxY

            if currentBottomPadding == bottomPadding {
                return
            }
        }

        tabBar.snp.updateConstraints {
            $0.bottom == bottomPadding
        }

        if !animated ||
           !isViewAppeared {
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
            completion: nil
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
        guard let selectedScreen = items[safe: selectedIndex]?.screen else {
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
                $0.bottom == tabBar.snp.top

                $0.setPaddings(
                    (0, 0, .noMetric, 0)
                )
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
