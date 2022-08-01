// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ScrollScreen:
    Screen,
    UIScrollViewDelegate {
    public var footerViewEffectStyle: ScrollScreenFooterView.EffectStyle = .none {
        willSet {
            footerBackgroundView.effectStyle = newValue
        }
    }

    public private(set) lazy var scrollView: UIScrollView = .init()
    public private(set) lazy var contentView: UIView = .init()
    public private(set) lazy var footerView: UIView = .init()

    private lazy var footerBackgroundView = ScrollScreenFooterView()

    open func customizeScrollAppearance() {
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }

    open func addScroll() {
        view.addSubview(
            scrollView
        )
        scrollView.snp.makeConstraints {
            $0.setPaddings(
                (0, 0, 0, 0)
            )
        }

        addContent()
    }

    open func updateScrollLayoutWhenViewDidLayoutSubviews() {
        if footerView.bounds.isEmpty {
            return
        }

        scrollView.setContentInset(
            bottom: footerView.bounds.height
        )
    }

    open func addContent() {
        scrollView.addSubview(
            contentView
        )
        contentView.snp.makeConstraints {
            $0.width == view

            $0.setPaddings(
                (0, 0, 0, 0)
            )
        }
    }

    open func addFooter() {
        view.addSubview(
            footerBackgroundView
        )
        footerBackgroundView.snp.makeConstraints {
            $0.setPaddings(
                (.noMetric, 0, 0, 0)
            )
        }

        footerBackgroundView.addSubview(
            footerView
        )
        footerView.snp.makeConstraints {
            $0.setPaddings(
                (0, 0, .noMetric, 0)
            )
            $0.setBottomPadding(
                0,
                inSafeAreaOf: footerBackgroundView
            )
        }
    }

    open override func customizeAppearance() {
        super.customizeAppearance()
        customizeScrollAppearance()
    }

    open override func prepareLayout() {
        super.prepareLayout()

        addScroll()
        addFooter()
    }

    open override func updateLayoutWhenViewDidLayoutSubviews() {
        super.updateLayoutWhenViewDidLayoutSubviews()

        if contentView.bounds.isEmpty {
            return
        }

        updateScrollLayoutWhenViewDidLayoutSubviews()
        updateLayoutOnScroll()
    }

    open override func setListeners() {
        super.setListeners()
        scrollView.delegate = self
    }

    /// <mark>
    /// UIScrollViewDelegate
    open func scrollViewDidScroll(
        _ scrollView: UIScrollView
    ) {
        updateLayoutOnScroll()
    }
}

extension ScrollScreen {
    private func updateLayoutOnScroll() {
        if footerView.bounds.isEmpty {
            return
        }

        footerBackgroundView.addBlur()

        let endOfContent = contentView.frame.maxY - scrollView.contentOffset.y
        footerBackgroundView.blurBackgroundView.isHidden = endOfContent <= footerBackgroundView.frame.minY
    }
}
