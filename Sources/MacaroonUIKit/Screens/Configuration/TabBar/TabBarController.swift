// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

open class TabBarController: ScreenLifeCycleObserver {
    public var isTabBarHidden = false
    private var tabBarSnapshot: UIView?
    
    public weak var screen: Screen! {
        didSet { screen.add(lifeCycleObserver: self) }
    }
    
    public init() {}
}

extension TabBarController {
    public func setNeedsTabBarAppearanceUpdateOnAppearing(
        animated: Bool
    ) {
        guard let tabBarContainer = screen.tabBarContainer else {
            return
        }

        if !isTabBarHidden {
            updateTabBarAppearanceOnStacked()
            return
        }

        tabBarContainer.setTabBarHidden(
            true,
            animated: animated
        )
    }

    public func setNeedsTabBarAppearanceUpdateOnAppeared() {
        guard let tabBarContainer = screen.tabBarContainer else {
            return
        }

        if !isTabBarHidden {
            removeTabBarSnapshot()
        }

        tabBarContainer.setTabBarHidden(
            isTabBarHidden,
            animated: false
        )
    }

    public func setNeedsTabBarAppearanceUpdateOnDisappeared() {
        if screen.tabBarContainer == nil {
            return
        }

        updateTabBarAppearanceOnPopped()
    }
}

extension TabBarController {
    private func updateTabBarAppearanceOnStacked() {
        if isTabBarHidden {
            return
        }

        guard let stack = screen.navigationController?.viewControllers else {
            return
        }
        guard let prevStackIndex =
                stack
                    .firstIndex(
                        of: screen
                    )
                    .unwrap(
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
        guard let previousViewControllerInStack = stack[prevStackIndex] as? Screen else {
            return
        }
        
        if !previousViewControllerInStack.tabController.isTabBarHidden {
            return
        }

        addTabBarSnaphot()
    }

    private func updateTabBarAppearanceOnPopped() {
        if isTabBarHidden {
            return
        }

        guard let stack = screen.navigationController?.viewControllers else {
            return
        }
        
        guard let nextStackIndex =
                stack.firstIndex(
                    of: screen
                )
                .unwrap(
                    {
                        $0 + 1
                    }
                )
                .unwrap(
                    where: {
                        $0 < stack.endIndex
                    }
                )
        else {
            return
        }
        guard let nextViewControllerInStack = stack[nextStackIndex] as? Screen else {
            return
        }
        
        if !nextViewControllerInStack.tabController.isTabBarHidden {
            return
        }

        addTabBarSnaphot()
    }

    private func addTabBarSnaphot() {
        if tabBarSnapshot.unwrap(
            where: {
                $0.isDescendant(
                    of: screen.view
                )
            }
        ) != nil {
            return
        }

        guard let tabBarContainer = screen.tabBarContainer else {
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

        screen.view.addSubview(
            tabBarSnapshot
        )
        tabBarSnapshot.frame =
            CGRect(
                origin: CGPoint(x: 0.0, y: screen.view.bounds.height - tabBar.bounds.height),
                size: tabBar.bounds.size
            )

        self.tabBarSnapshot = tabBarSnapshot
    }

    private func removeTabBarSnapshot() {
        tabBarSnapshot?.removeFromSuperview()
        tabBarSnapshot = nil
    }
}


/// <mark>
/// Hashable
extension TabBarController {
    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(ObjectIdentifier(self))
    }

    public static func == (
        lhs: TabBarController,
        rhs: TabBarController
    ) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
