// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol NavigationBarConfigurable: AnyObject {
    var isNavigationBarHidden: Bool { get set }
    /// Back/Dismiss bar button items should not be added into leftBarItems&rightBarItems.
    /// They will be inserted automatically when setNeedsNavigationBarAppearanceUpdate() is called.
    var leftBarItems: [NavigationBarItemConvertible] { get set }
    var rightBarItems: [NavigationBarItemConvertible] { get set }
    /// Return true if pop/dismiss should be hidden.
    var hidesCloseBarItem: Bool { get }
    var hidesDismissBarItemIniOS13AndLater: Bool { get }

    var disablesInteractivePopGesture: Bool { get }

    func makeDismissNavigationBarItem() -> NavigationBarItemConvertible
    func makePopNavigationBarItem() -> NavigationBarItemConvertible
}

extension NavigationBarConfigurable {
    public var hidesCloseBarItem: Bool {
        return false
    }
    public var hidesDismissBarItemIniOS13AndLater: Bool {
        return false
    }
}

extension NavigationBarConfigurable where Self: UIViewController {
    public func setNeedsNavigationBarAppearanceUpdate() {
        setNeedsNavigationBarLeftBarItemsUpdate()
        setNeedsNavigationBarRightBarItemsUpdate()
    }

    public func setNeedsNavigationBarAppearanceUpdateOnAppearing(animated: Bool = true) {
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: animated)
    }

    public func setNeedsNavigationBarLeftBarItemsUpdate() {
        guard let navigationController = navigationController else {
            return
        }
        if hidesCloseBarItem {
            navigationItem.hidesBackButton = true
        } else {
            navigationItem.hidesBackButton = false

            if navigationController.viewControllers.first == self {
                if presentingViewController != nil {
                    iOS13AndLater(
                        execute: {
                            if !hidesDismissBarItemIniOS13AndLater {
                                leftBarItems.insert(makeDismissNavigationBarItem(), at: 0)
                            }
                        },
                        else: {
                            leftBarItems.insert(makeDismissNavigationBarItem(), at: 0)
                        }
                    )
                }
            } else {
                leftBarItems.insert(makePopNavigationBarItem(), at: 0)
            }
        }   
        navigationItem.leftBarButtonItems = leftBarItems.map { $0.asSystemBarButtonItem() }
    }

    public func setNeedsNavigationBarRightBarItemsUpdate() {
        navigationItem.rightBarButtonItems = rightBarItems.map { $0.asSystemBarButtonItem() }
    }
}
