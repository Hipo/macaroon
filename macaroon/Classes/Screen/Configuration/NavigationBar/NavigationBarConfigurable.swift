// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol NavigationBarConfigurable: class {
    associatedtype BarButtonItem: NavigationBarButtonItemConvertible

    var isNavigationBarHidden: Bool { get set }
    /// Back/Dismiss bar button items should not be added into leftBarButtonItems&rightBarButtonItems.
    /// They will be inserted automatically when setNeedsNavigationBarAppearanceUpdate() is called.
    var leftBarButtonItems: [BarButtonItem] { get set }
    var rightBarButtonItems: [BarButtonItem] { get set }
    /// Return true if pop/dismiss should be hidden.
    var hidesCloseBarButtonItem: Bool { get }

    func customizeNavigationBarAppearance()

    func canPop() -> Bool
    func canDismiss() -> Bool
}

extension NavigationBarConfigurable {
    public var hidesCloseBarButtonItem: Bool {
        return false
    }

    public func canPop() -> Bool {
        return true
    }

    public func canDismiss() -> Bool {
        return true
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
                    addDismissBarButton()
                }
            } else {
                addPopBarButtonItem()
            }
        }
        navigationItem.leftBarButtonItems = leftBarButtonItems.map { $0.asSystemBarButtonItem() }
    }

    public func setNeedsNavigationBarRightBarButtonItemsUpdate() {
        navigationItem.rightBarButtonItems = rightBarButtonItems.map { $0.asSystemBarButtonItem() }
    }
}

extension NavigationBarConfigurable where Self: UIViewController {
    private func addDismissBarButton() {
        let dismissBarButtonItem = BarButtonItem.dismiss { [unowned self] in
            if self.canDismiss() {
                self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        if let barButtonItem = dismissBarButtonItem {
            leftBarButtonItems.insert(barButtonItem, at: 0)
        }
    }

    private func addPopBarButtonItem() {
        let popBarButtonItem = BarButtonItem.pop { [unowned self] in
            if self.canPop() {
                self.navigationController?.popViewController(animated: true)
            }
        }
        if let barButtonItem = popBarButtonItem {
            leftBarButtonItems.insert(barButtonItem, at: 0)
        }
    }
}
