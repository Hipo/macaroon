// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public protocol Scrollable: AnyObject {
    var pinsTopToSafeArea: Bool { get set }
    var pinsBottomToSafeArea: Bool { get set }

    var alwaysPinsFooterToBottom: Bool { get set }

    var ignoresContentLayoutUpdates: Bool { get set }

    var scrollView: ScrollView { get }
    var contentView: UIView { get }
    var footerView: UIView { get }
}

extension Scrollable where Self: UIViewController {
    public func addScrollView() {
        view.addSubview(scrollView)
        updateScrollViewLayoutWhenScrollingAreaChanged()

        addContentView()
        addFooterView()
    }

    public func updateScrollViewLayoutWhenScrollingAreaChanged() {
        scrollView.snp.remakeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()

            if pinsTopToSafeArea {
                maker.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                maker.top.equalToSuperview()
            }
            if pinsBottomToSafeArea {
                maker.bottom.equalTo(view.safeAreaLayoutGuide)
            } else {
                maker.bottom.equalToSuperview()
            }
        }
    }

    public func addContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.leading.equalTo(view)
            maker.trailing.equalTo(view)
        }
    }

    public func addFooterView() {
        scrollView.addSubview(footerView)
        footerView.snp.makeConstraints { maker in
            maker.width.equalTo(contentView)
            maker.top.equalTo(contentView.snp.bottom)
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }

    public func updateFooterViewLayoutWhenViewDidLayoutSubviews() {
        if ignoresContentLayoutUpdates {
            return
        }
        if scrollView.bounds.isEmpty {
            return
        }
        let scrollHeight = scrollView.bounds.height
        let contentHeight = contentView.bounds.height
        let footerHeight = footerView.bounds.height
        let scrollableHeight = contentHeight + footerHeight + scrollView.adjustedContentInset.y

        footerView.snp.updateConstraints { maker in
            let offset: CGFloat

            if scrollableHeight >= scrollHeight ||
               (contentHeight == 0.0 && !alwaysPinsFooterToBottom) ||
               footerHeight == 0.0 {
                offset = 0.0
            } else {
                offset = scrollHeight - scrollableHeight
            }
            maker.top.equalTo(contentView.snp.bottom).offset(offset)
        }
    }

    public func updateFooterViewLayoutWhenContentDidChange() {
        contentView.layoutIfNeeded()
        updateFooterViewLayoutWhenViewDidLayoutSubviews()
    }
}
