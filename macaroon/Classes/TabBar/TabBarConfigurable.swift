// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public protocol TabBarConfigurable: AnyObject {
    var isTabBarHidden: Bool { get set }
    var tabBarSnapshot: UIView? { get set }
}

extension TabBarConfigurable where Self: UIViewController {
    public func setNeedsTabBarAppearanceUpdateOnAppearing(animated: Bool = true) {
        guard let tabBarContainer = tabBarContainer else { return }
        
        isTabBarHidden.continue(
            isTrue: { tabBarContainer.setTabBarHidden(true, animated: animated) },
            isFalse: updateTabBarAppearanceOnStacked
        )
    }

    public func setNeedsTabBarAppearanceUpdateOnAppeared() {
        guard let tabBarContainer = tabBarContainer else { return }

        if !isTabBarHidden {
            removeTabBarSnapshot()
        }
        tabBarContainer.setTabBarHidden(isTabBarHidden, animated: false)
    }

    public func setNeedsTabBarAppearanceUpdateOnDisappeared() {
        if tabBarContainer == nil { return }
        updateTabBarAppearanceOnPopped()
    }
}

extension TabBarConfigurable where Self: UIViewController {
    private func updateTabBarAppearanceOnStacked() {
        if isTabBarHidden { return }

        guard let stackedViewControllers = navigationController?.viewControllers else { return }
        guard let stackIndex = stackedViewControllers.firstIndex(of: self)
            .unwrapConditionally(where: { $0 > stackedViewControllers.startIndex && $0 == stackedViewControllers.index(before: stackedViewControllers.endIndex)}) // 1 -> Root, 2 -> Popping
        else { return }
        guard let previousViewControllerInStack = stackedViewControllers[stackedViewControllers.index(before: stackIndex)] as? TabBarConfigurable else { return }

        if previousViewControllerInStack.isTabBarHidden {
            addTabBarSnaphot()
        }
    }

    private func updateTabBarAppearanceOnPopped() {
        if isTabBarHidden { return }

        guard let stackedViewControllers = navigationController.unwrapIfPresent(either: { $0.viewControllers }) else { return }
        guard let nextStackIndex = stackedViewControllers.firstIndex(of: self)
            .unwrapIfPresent(either: { stackedViewControllers.index(after: $0) })
            .unwrapConditionally(where: { $0 < stackedViewControllers.endIndex })
        else { return }
        if (stackedViewControllers[nextStackIndex] as? TabBarConfigurable).unwrapConditionally(where: { !$0.isTabBarHidden }) != nil { return }

        addTabBarSnaphot()
    }

    private func addTabBarSnaphot() {
        if tabBarSnapshot.unwrapConditionally(where: { $0.isDescendant(of: view) }) != nil { return }

        guard let tabBarContainer = tabBarContainer else { return }

        let tabBar = tabBarContainer.tabBar

        guard let newTabBarSnaphot = tabBar.snapshotView(afterScreenUpdates: true) else { return }

        /// <note> Because snapshow does not copy shadow layer.
        newTabBarSnaphot.layer.shadowColor = tabBar.shadowLayer?.shadowColor ?? UIColor.black.cgColor
        newTabBarSnaphot.layer.shadowOffset = tabBar.shadowLayer?.shadowOffset ?? CGSize(width: 0.0, height: -3.0)
        newTabBarSnaphot.layer.shadowRadius = tabBar.shadowLayer?.shadowRadius ?? 3.0
        newTabBarSnaphot.layer.shadowOpacity = tabBar.shadowLayer?.shadowOpacity ?? 0.0
        newTabBarSnaphot.layer.shadowPath = tabBar.shadowLayer?.shadowPath
        newTabBarSnaphot.layer.masksToBounds = tabBar.layer.masksToBounds

        view.addSubview(newTabBarSnaphot)
        newTabBarSnaphot.frame = CGRect(origin: CGPoint(x: 0.0, y: view.bounds.height - tabBar.bounds.height), size: tabBar.bounds.size)

        tabBarSnapshot = newTabBarSnaphot
    }

    private func removeTabBarSnapshot() {
        tabBarSnapshot?.removeFromSuperview()
        tabBarSnapshot = nil
    }
}
