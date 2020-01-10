// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class TabBarContainer<SomeTabBar: TabBarPresentable>: UIViewController, ScreenComposable {
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

    public let tabBar: SomeTabBar

    open override var childForStatusBarHidden: UIViewController? {
        return selectedContent
    }
    open override var childForStatusBarStyle: UIViewController? {
        return selectedContent
    }

    public init(_ tabBar: SomeTabBar) {
        self.tabBar = tabBar
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func customizeAppearance() {
        customizeViewAppearance()
    }

    open func customizeViewAppearance() { }

    open func prepareLayout() {
        addTabBar()
        updateLayoutWhenItemsChanged()
    }

    open func updateLayoutWhenItemsChanged() {
        tabBar.barButtonItems = items.values(\.barButtonItem)

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
        tabBar.selectedBarButtonIndex = items.firstIndexOfElement(equalsTo: selectedItem, on: \.name)
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
