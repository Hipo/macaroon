// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol NavigationBarConfigurable: class {
    var isNavigationBarHidden: Bool { get set }
    /// Back/Dismiss bar button items should not be added into leftBarButtonItems&rightBarButtonItems.
    /// They will be inserted automatically when setNeedsNavigationBarAppearanceUpdate() is called.
    var leftBarButtonItems: [NavigationBarButtonItemConvertible] { get set }
    var rightBarButtonItems: [NavigationBarButtonItemConvertible] { get set }
    /// Return true if pop/dismiss should be hidden.
    var hidesCloseBarButtonItem: Bool { get }

    func makeDismissNavigationBarButtonItem() -> NavigationBarButtonItemConvertible
    func makePopNavigationBarButtonItem() -> NavigationBarButtonItemConvertible
}

extension NavigationBarConfigurable {
    public var hidesCloseBarButtonItem: Bool {
        return false
    }
}

extension NavigationBarConfigurable where Self: UIViewController {
    public func setNeedsNavigationBarAppearanceUpdate() {
        setNeedsNavigationBarLeftBarButtonItemsUpdate()
        setNeedsNavigationBarRightBarButtonItemsUpdate()
    }

    public func setNeedsNavigationBarAppearanceUpdateOnAppearing(animated: Bool = true) {
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: animated)
    }

    public func setNeedsNavigationBarLeftBarButtonItemsUpdate() {
        guard let navigationController = navigationController else {
            return
        }
        if hidesCloseBarButtonItem {
            navigationItem.hidesBackButton = true
        } else {
            navigationItem.hidesBackButton = false

            if navigationController.viewControllers.first == self {
                if presentingViewController != nil {
                    leftBarButtonItems.insert(makeDismissNavigationBarButtonItem(), at: 0)
                }
            } else {
                leftBarButtonItems.insert(makePopNavigationBarButtonItem(), at: 0)
            }
        }   
        navigationItem.leftBarButtonItems = leftBarButtonItems.map { $0.asSystemBarButtonItem() }
    }

    public func setNeedsNavigationBarRightBarButtonItemsUpdate() {
        navigationItem.rightBarButtonItems = rightBarButtonItems.map { $0.asSystemBarButtonItem() }
    }
}
