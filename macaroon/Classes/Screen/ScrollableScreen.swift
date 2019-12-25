// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ScrollableScreen<SomeScreenLaunchArgs: ScreenLaunchArgsConvertible, SomeBarButtonItem: NavigationBarButtonItemConvertible>: Screen<SomeScreenLaunchArgs, SomeBarButtonItem> {
    public var pinsToSafeAreaTop = true {
        didSet {
            if isViewLoaded &&
               pinsToSafeAreaTop != oldValue {
                updateScrollViewLayout()
            }
        }
    }
    public var pinsToSafeAreaBottom = false {
        didSet  {
            if isViewLoaded &&
               pinsToSafeAreaBottom != oldValue {
                updateScrollViewLayout()
            }
        }
    }

    public var alwaysPinsFooterToBottom = true {
        didSet {
            if isViewLoaded {
                view.layoutIfNeeded()
            }
        }
    }

    public private(set) lazy var scrollView = ScrollView()
    public private(set) lazy var contentView = UIView()
    public private(set) lazy var footerView = UIView()

    open override func customizeAppearance() {
        super.customizeAppearance()
        customizeScrollViewAppearance()
    }

    open func customizeScrollViewAppearance() {
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }

    open override func prepareLayout() {
        super.prepareLayout()
        addScrollView()
        addContentView()
        addFooterView()
    }

    open override func updateLayoutWhenViewDidLayoutSubviews() {
        super.updateLayoutWhenViewDidLayoutSubviews()

        if scrollView.bounds.isEmpty {
            return
        }
        let scrollHeight = scrollView.bounds.height
        let contentHeight = contentView.bounds.height
        let footerHeight = footerView.bounds.height
        let scrollableHeight = contentHeight + footerHeight

        footerView.snp.updateConstraints { maker in
            let offset: CGFloat

            if scrollableHeight >= scrollHeight ||
               (contentHeight == 0.0 && !alwaysPinsFooterToBottom) ||
               footerHeight == 0.0 {
                offset = 0.0
            } else {
                offset = scrollHeight - scrollableHeight
            }
            maker.top.equalTo(self.contentView.snp.bottom).offset(offset)
        }
    }

    open func addScrollView() {
        view.addSubview(scrollView)
        updateScrollViewLayout()
    }

    open func updateScrollViewLayout() {
        scrollView.snp.remakeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()

            if pinsToSafeAreaTop {
                maker.top.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                maker.top.equalToSuperview()
            }
            if pinsToSafeAreaBottom {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                maker.bottom.equalToSuperview()
            }
        }
    }

    open func addContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.leading.equalTo(view)
            maker.trailing.equalTo(view)
        }
    }

    open func addFooterView() {
        scrollView.addSubview(footerView)
        footerView.snp.makeConstraints { maker in
            maker.width.equalTo(self.contentView)
            maker.top.equalTo(self.contentView.snp.bottom)
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
}
