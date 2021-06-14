// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public protocol TabBarConfigurable: UIViewController {
    var tabBarHidden: Bool { get set }
    var tabBarSnapshot: UIView? { get set }
}

extension TabBarConfigurable {
    public func setNeedsTabBarAppearanceUpdateOnAppearing(
        animated: Bool
    ) {
        guard let tabBarContainer = tabBarContainer else {
            return
        }

        if !tabBarHidden {
            updateTabBarAppearanceOnStacked()
            return
        }

        tabBarContainer.setTabBarHidden(
            true,
            animated: animated
        )
    }

    public func setNeedsTabBarAppearanceUpdateOnAppeared() {
        guard let tabBarContainer = tabBarContainer else {
            return
        }

        if !tabBarHidden {
            removeTabBarSnapshot()
        }

        tabBarContainer.setTabBarHidden(
            tabBarHidden,
            animated: false
        )
    }

    public func setNeedsTabBarAppearanceUpdateOnDisappeared() {
        if tabBarContainer == nil {
            return
        }

        updateTabBarAppearanceOnPopped()
    }
}

extension TabBarConfigurable {
    private func updateTabBarAppearanceOnStacked() {
        if tabBarHidden {
            return
        }

        guard let stack = navigationController?.viewControllers else {
            return
        }
        guard let prevStackIndex =
                stack
                    .firstIndex(
                        of: self
                    )
                    .unwrapConditionally(
                        where: {
                            $0 > stack.startIndex &&
                            $0 == stack.lastIndex
                        }
                    )
                    .unwrap(
                        {
                            $0 - 1
                        }
                    )
        else {
            return
        }
        guard let previousViewControllerInStack = stack[prevStackIndex] as? TabBarConfigurable else {
            return
        }

        if !previousViewControllerInStack.tabBarHidden {
            return
        }

        addTabBarSnaphot()
    }

    private func updateTabBarAppearanceOnPopped() {
        if tabBarHidden {
            return
        }

        guard let stack = navigationController?.viewControllers else {
            return
        }
        guard let nextStackIndex =
                stack.firstIndex(
                    of: self
                )
                .unwrap(
                    {
                        $0 + 1
                    }
                )
                .unwrapConditionally(
                    where: {
                        $0 < stack.endIndex
                    }
                )
        else {
            return
        }
        guard let nextViewControllerInStack = stack[nextStackIndex] as? TabBarConfigurable else {
            return
        }

        if !nextViewControllerInStack.tabBarHidden {
            return
        }

        addTabBarSnaphot()
    }

    private func addTabBarSnaphot() {
        if tabBarSnapshot.unwrapConditionally(
            where: {
                $0.isDescendant(
                    of: view
                )
            }
        ) != nil {
            return
        }

        guard let tabBarContainer = tabBarContainer else {
            return
        }

        let tabBar = tabBarContainer.tabBar
        let someTabBarSnapshot =
            tabBar.snapshotView(
                afterScreenUpdates: true
            )

        guard let tabBarSnapshot = someTabBarSnapshot else {
            return
        }

        /// <note> Because snapshow does not copy shadow layer.
        tabBarSnapshot.layer.shadowColor = tabBar.shadowLayer.shadowColor ?? UIColor.black.cgColor
        tabBarSnapshot.layer.shadowOffset = tabBar.shadowLayer.shadowOffset
        tabBarSnapshot.layer.shadowRadius = tabBar.shadowLayer.shadowRadius
        tabBarSnapshot.layer.shadowOpacity = tabBar.shadowLayer.shadowOpacity
        tabBarSnapshot.layer.shadowPath = tabBar.shadowLayer.shadowPath
        tabBarSnapshot.layer.masksToBounds = tabBar.layer.masksToBounds

        view.addSubview(
            tabBarSnapshot
        )
        tabBarSnapshot.frame =
            CGRect(
                origin: CGPoint(x: 0.0, y: view.bounds.height - tabBar.bounds.height),
                size: tabBar.bounds.size
            )

        self.tabBarSnapshot = tabBarSnapshot
    }

    private func removeTabBarSnapshot() {
        tabBarSnapshot?.removeFromSuperview()
        tabBarSnapshot = nil
    }
}
