// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class TabBarContainer: UIViewController, ScreenComposable {
    public var items: [TabBarItemConvertible] = [] {
        didSet {
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
    public var selectedContent: UIViewController?

    public private(set) lazy var tabBar = TabBar()

    open override var childForStatusBarHidden: UIViewController? {
        return selectedContent
    }
    open override var childForStatusBarStyle: UIViewController? {
        return selectedContent
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
            removeCurrentSelectedContent()
            tabBar.selectedBarButtonIndex = nil
            return
        }
        addNewSelectedContent()
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
        if !animated || !isAppeared { return }

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

    public func addNewSelectedContent() {
        removeCurrentSelectedContent()

        if let content = selectedItem?.content {
            selectedContent = addContent(content) { contentView in
                view.insertSubview(contentView, belowSubview: tabBar)
                contentView.snp.makeConstraints { maker in
                    maker.top.equalToSuperview()
                    maker.leading.equalToSuperview()
                    maker.trailing.equalToSuperview()
                    maker.bottom.equalTo(tabBar.snp.top)
                }
            }
        }
    }

    public func removeCurrentSelectedContent() {
        selectedContent?.removeFromContainer()
        selectedContent = nil
    }
}
