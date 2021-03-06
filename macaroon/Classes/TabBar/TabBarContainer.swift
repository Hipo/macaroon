// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class TabBarContainer: UIViewController, TabbedContainer, ScreenComposable, ScreenRoutable {
    public var flowIdentifier: String = "main"
    public var pathIdentifier: String = "tabbarContainer"

    public var items: [TabBarItemConvertible] = [] {
        didSet {
            screens = items.compactMap {
                $0.screen
            }

            updateLayoutWhenItemsChanged()
        }
    }
    public var selectedItem: TabBarItemConvertible? {
        didSet {
            if let selectedItem = selectedItem {
                if !selectedItem.equalsTo(oldValue) {
                    updateLayoutWhenSelectedItemChanged()
                }
            } else {
                if oldValue != nil {
                    updateLayoutWhenSelectedItemChanged()
                }
            }
        }
    }
    public var screens: [UIViewController] = []
    /// <todo>
    /// Selecting selectedScreen should change the current item.
    public var selectedScreen: UIViewController?

    public private(set) lazy var tabBar = TabBar()

    open override var childForStatusBarHidden: UIViewController? {
        return selectedScreen
    }
    open override var childForStatusBarStyle: UIViewController? {
        return selectedScreen
    }

    private var isAppeared = false

    open func customizeAppearance() {
        customizeViewAppearance()
    }

    open func customizeViewAppearance() { }

    open func prepareLayout() {
        addTabBar()
        updateLayoutWhenItemsChanged()
    }

    open func updateLayoutWhenItemsChanged() {
        tabBar.barButtonItems = items.map(\.barButtonItem)

        if selectedItem == nil {
            selectedItem = items.first
        } else {
            updateLayoutWhenSelectedItemChanged()
        }
    }

    open func updateLayoutWhenSelectedItemChanged() {
        guard let selectedItem = selectedItem else {
            removeCurrentSelectedScreen()
            tabBar.selectedBarButtonIndex = nil
            return
        }
        addNewSelectedScreen()
        tabBar.selectedBarButtonIndex = items.firstIndex(of: selectedItem, equals: \.name)
    }

    open func setListeners() {
        tabBar.barButtonDidSelect = { [unowned self] index in
            self.selectedItem = self.items[index]
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        compose()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isAppeared = true
    }

    open func setTabBarHidden(_ isHidden: Bool, animated: Bool) {
        tabBar.snp.updateConstraints { maker in
            maker.bottom.equalToSuperview().inset(isHidden ? -tabBar.bounds.height : 0.0)
        }
        if !animated || !isAppeared {
            return
        }

        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) { [unowned self] in
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }

    open func getBadge(forItemAt index: Int) -> String? {
        return tabBar.getBadge(forBarButtonAt: index)
    }

    open func set(badge: String?, forItemAt index: Int, animated: Bool) {
        tabBar.set(badge: badge, forBarButtonAt: index, animated: animated)
    }
}

extension TabBarContainer {
    public func addTabBar() {
        view.addSubview(tabBar)
        tabBar.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }

    public func addNewSelectedScreen() {
        removeCurrentSelectedScreen()

        if let screen = selectedItem?.screen {
            selectedScreen =
                addScreen(
                    screen
                ) {
                    screenView in
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
    }

    public func removeCurrentSelectedScreen() {
        selectedScreen?.removeFromContainer()
        selectedScreen = nil
    }
}
