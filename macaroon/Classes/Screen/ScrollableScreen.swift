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

    public private(set) lazy var scrollView = ScrollView()
    public private(set) lazy var contentView = UIView()

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
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.leading.equalTo(view)
            maker.trailing.equalTo(view)
        }
    }
}
