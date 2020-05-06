// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class NavigationContainer: UINavigationController, ScreenComposable {
    public var isPushAnimationInProgress = false

    open override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return topViewController?.preferredStatusBarUpdateAnimation ?? .none
    }

    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }

    open func customizeAppearance() {
        customizeNavigationBarAppearance()
        customizeViewAppearance()
    }

    open func customizeNavigationBarAppearance() { }
    open func customizeViewAppearance() { }
    open func prepareLayout() { }

    open func setListeners() {
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }

    open func linkInteractors() { }

    open override func viewDidLoad() {
        super.viewDidLoad()
        compose()
    }

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushAnimationInProgress = true
        super.pushViewController(viewController, animated: animated)
    }
}

extension NavigationContainer: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        (navigationController as? Self)?.isPushAnimationInProgress = false
    }
}

extension NavigationContainer: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer != interactivePopGestureRecognizer { return true }

        if (visibleViewController as? NavigationBarConfigurable).unwrapConditionally(where: { $0.disablesInteractivePopGesture }) != nil {
            return false
        }
        return viewControllers.count > 1 && !isPushAnimationInProgress
    }
}
