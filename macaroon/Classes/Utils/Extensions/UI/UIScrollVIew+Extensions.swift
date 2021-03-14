// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UIScrollView {
    public var isScrollAtTop: Bool {
        return contentOffset.y <= adjustedContentInset.top
    }
}

extension UIScrollView {
    public func setContentInset(
        _ contentInset: LayoutPaddings
    ) {
        setContentInset(
            horizontal: (contentInset.leading, contentInset.trailing)
        )
        setContentInset(
            vertical: (contentInset.top, contentInset.bottom)
        )
    }

    public func setContentInset(
        horizontal: LayoutHorizontalPaddings
    ) {
        setContentInset(
            left: horizontal.leading
        )
        setContentInset(
            right: horizontal.trailing
        )
    }

    public func setContentInset(
        vertical: LayoutVerticalPaddings
    ) {
        setContentInset(
            top: vertical.top
        )
        setContentInset(
            bottom: vertical.bottom
        )
    }

    public func setContentInset(
        top: LayoutMetric
    ) {
        if top.isNoMetric {
            return
        }

        var mContentInset = contentInset
        mContentInset.top = top
        contentInset = mContentInset

        var mScrollIndicatoInset = scrollIndicatorInsets
        mScrollIndicatoInset.top = top
        scrollIndicatorInsets = mScrollIndicatoInset
    }

    public func setContentInset(
        left: LayoutMetric
    ) {
        if left.isNoMetric {
            return
        }

        var mContentInset = contentInset
        mContentInset.left = left
        contentInset = mContentInset

        var mScrollIndicatoInset = scrollIndicatorInsets
        mScrollIndicatoInset.left = left
        scrollIndicatorInsets = mScrollIndicatoInset
    }

    public func setContentInset(
        bottom: LayoutMetric
    ) {
        if bottom.isNoMetric {
            return
        }

        var mContentInset = contentInset
        mContentInset.bottom = bottom
        contentInset = mContentInset

        var mScrollIndicatoInset = scrollIndicatorInsets
        mScrollIndicatoInset.bottom = bottom
        scrollIndicatorInsets = mScrollIndicatoInset
    }

    public func setContentInset(
        right: LayoutMetric
    ) {
        if right.isNoMetric {
            return
        }

        var mContentInset = contentInset
        mContentInset.right = right
        contentInset = mContentInset

        var mScrollIndicatoInset = scrollIndicatorInsets
        mScrollIndicatoInset.right = right
        scrollIndicatorInsets = mScrollIndicatoInset
    }
}

extension UIScrollView {
    public func scrollToBottom(
        force: Bool = false,
        animated: Bool = true
    ) {
        let height = bounds.height
        let contentHeight = contentSize.height + adjustedContentInset.y

        if force ||
           height < contentHeight {
            setContentOffset(
                CGPoint(x: contentOffset.x, y: contentHeight - height),
                animated: animated
            )
        }
    }
}
