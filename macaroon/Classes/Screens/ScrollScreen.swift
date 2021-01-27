// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ScrollScreen:
    Screen,
    UIScrollViewDelegate {
    public lazy var scrollView = ScrollView()
    public lazy var contentView = UIView()
    public lazy var footerView = UIView()

    public var pinsFooterToTopForEmptyContent = true {
        didSet {
            if !isViewLoaded { return }
            updateLayoutWhenViewDidLayoutSubviews()
        }
    }

    open override func customizeAppearance() {
        super.customizeAppearance()
        customizeScrollAppearance()
    }

    open override func prepareLayout() {
        super.prepareLayout()
        addScroll()
    }

    open override func updateLayoutWhenViewDidLayoutSubviews() {
        super.updateLayoutWhenViewDidLayoutSubviews()
        updateFooterLayoutWhenViewDidLayoutSubviews()
    }

    open override func setListeners() {
        super.setListeners()
        scrollView.delegate = self
    }

    open func customizeScrollAppearance() {
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }

    open func addScroll() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.setPaddings((0, 0, 0, 0))
        }

        addContent()
        addFooter()
    }

    open func addContent() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.width == view
            $0.setPaddings((0, 0, .noConstraint, 0))
        }
    }

    open func addFooter() {
        scrollView.addSubview(footerView)
        footerView.snp.makeConstraints {
            $0.width == view
            $0.top == contentView.snp.bottom
            $0.setPaddings((.noConstraint, 0, 0, 0))
        }
    }

    open func updateFooterLayoutWhenViewDidLayoutSubviews() {
        if !isViewLoaded { return }
        if scrollView.bounds.isEmpty { return }

        let scrollHeight = scrollView.bounds.height
        let contentHeight = contentView.bounds.height
        let footerHeight = contentView.bounds.height
        let scrollableHeight =
            contentHeight +
            footerHeight +
            scrollView.adjustedContentInset.y

        footerView.snp.makeConstraints {
            let offset: CGFloat

            if scrollableHeight > scrollHeight ||
               footerHeight == 0.0 ||
               (contentHeight == 0.0 && pinsFooterToTopForEmptyContent) {
                offset = 0.0
            } else {
                offset = scrollHeight - scrollableHeight
            }

            $0.top == contentView.snp.bottom + offset
        }
    }

    open func updateFooterLayoutWhenContentDidChange() {
        if !isViewLoaded { return }

        contentView.layoutIfNeeded()
        updateFooterLayoutWhenViewDidLayoutSubviews()
    }

    /// <mark> UIScrollViewDelegate
    open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        updateLayoutWhenViewDidLayoutSubviews()
    }
}
