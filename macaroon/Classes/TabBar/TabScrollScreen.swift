// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TabScrollScreen: UIViewController {
    var tabSavedScrollOffset: CGPoint { get set }
    var tabScrollView: UIScrollView { get }
}

extension TabScrollScreen {
    public func preserveScrollOffsetWhenSafeAreaDidChange(
        additionalContentAreaInsets: UIEdgeInsets = .zero
    ) {
        guard let tabBarContainer = tabBarContainer else {
            return
        }

        /// <note>
        /// Tab bar is hidden initially.
        if !tabBarContainer.isViewAppeared,
           tabBarContainer.isTabBarHidden {
            return
        }

        /// <note>
        /// The `additionalSafeAreaInsets` is being used to display the content at the bottom over
        /// the tab bar. After a push transition, it is updated so that it doesn't put an additional
        /// bottom inset if the tab bar is hidden in the inner screen. When coming back, it is
        /// reverted to what it was before the push transition. Below code just preserves the scroll
        /// position between push/pop transitions.

        let tabBarHeight = tabBarContainer.tabBar.bounds.height

        if view.safeAreaInsets.bottom < tabBarHeight {
            /// <note>
            /// Tab bar is hidden
            tabSavedScrollOffset = tabScrollView.contentOffset

            tabScrollView.setContentInset(
                bottom:
                    tabBarHeight +
                    additionalContentAreaInsets.bottom -
                    view.compactSafeAreaInsets.bottom
            )
        } else {
            /// <note>
            /// Tab bar is visible
            tabScrollView.setContentInset(
                bottom: additionalContentAreaInsets.bottom
            )

            tabScrollView.contentOffset = tabSavedScrollOffset
        }
    }
}

extension TabScrollScreen where Self: ScrollScreen {
    public var tabScrollView: UIScrollView {
        return scrollView
    }
}

extension TabScrollScreen where Self: ListScreen {
    public var tabScrollView: UIScrollView {
        return listView
    }
}
