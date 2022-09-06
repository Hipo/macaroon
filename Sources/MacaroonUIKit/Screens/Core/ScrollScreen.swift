// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ScrollScreen:
    Screen,
    UIScrollViewDelegate {
    public var footerBackgroundEffect: Effect? {
        get { footerBackgroundView.effect }
        set { footerBackgroundView.effect = newValue }
    }

    public private(set) lazy var scrollView: UIScrollView = .init()
    public private(set) lazy var contentView: UIView = .init()
    public private(set) lazy var footerView: UIView = .init()

    public private(set) lazy var footerBackgroundView = EffectView()

    open func customizeScrollAppearance() {
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }

    open func addScroll() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top == 0
            $0.leading == 0
            $0.bottom == 0
            $0.trailing == 0
        }

        addContent()
    }

    open func updateScrollLayoutWhenViewDidLayoutSubviews() {
        if !footerView.bounds.isEmpty {
            scrollView.setContentInset(bottom: footerView.bounds.height)
        }
    }

    open func addContent() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.width == view
            $0.top == 0
            $0.leading == 0
            $0.bottom == 0
            $0.trailing == 0
        }
    }

    open func addFooter() {
        view.addSubview(footerBackgroundView)
        footerBackgroundView.snp.makeConstraints {
            $0.leading == 0
            $0.bottom == 0
            $0.trailing == 0
        }

        footerBackgroundView.addSubview(footerView)
        footerView.snp.makeConstraints {
            $0.top == 0
            $0.leading == 0
            $0.bottom == footerBackgroundView.safeAreaLayoutGuide.snp.bottom
            $0.trailing == 0
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

        let endOfContent = contentView.frame.maxY - scrollView.contentOffset.y
        let hidesFooterBackgroundEffect = endOfContent <= footerBackgroundView.frame.minY
        footerBackgroundView.setEffectHidden(hidesFooterBackgroundEffect)
    }
}
