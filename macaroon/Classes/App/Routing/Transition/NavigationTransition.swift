//// Copyright © 2019 hipolabs. All rights reserved.
//
//import Foundation
//
//public protocol NavigationTransition: Transition {
//    func prepareForTransition(
//        to screens: [ScreenRoutable],
//        from fromScreen: ScreenRoutable
//    )
//}
//
//extension NavigationTransition {
//    public func prepareForTransition(
//        to screens: [ScreenRoutable],
//        from fromScreen: ScreenRoutable
//    ) {
//        guard
//            let toScreen = screens.last as? StatusBarConfigurable,
//            let fromScreen = fromScreen as? StatusBarConfigurable
//        else { return }
//
//        let isStatusBarHidden = fromScreen.isStatusBarHidden
//        toScreen.hidesStatusBarOnAppeared = isStatusBarHidden
//        toScreen.isStatusBarHidden = isStatusBarHidden
//    }
//}
//
//public struct DefaultPushTransition: NavigationTransition {
//    public var completion: (() -> Void)?
//
//    public let animated: Bool
//
//    public init(
//        animated: Bool = true,
//        completion: (() -> Void)? = nil
//    ) {
//        self.animated = animated
//        self.completion = completion
//    }
//
//    public func perform(
//        to screens: [ScreenRoutable],
//        from fromScreen: ScreenRoutable
//    ) {
//        if screens.isEmpty { return }
//
//        guard let navigationContainer =
//                fromScreen as? UINavigationController ?? fromScreen.navigationController
//        else { return }
//
//        prepareForTransition(to: screens, from: fromScreen)
//
//        if screens.count == 1 {
//            let screen = screens[screens.startIndex]
//            navigationContainer.pushViewController(screen, animated: animated, completion: completeTransition)
//        } else {
//            let currentScreens = navigationContainer.viewControllers
//            let lastScreens = currentScreens + screens
//            navigationContainer.setViewControllers(lastScreens, animated: animated, completion: completeTransition)
//        }
//    }
//}
//
//public struct DefaultStackTransition: NavigationTransition {
//    public var completion: (() -> Void)?
//
//    public let animated: Bool
//
//    public init(
//        animated: Bool = true,
//        completion: (() -> Void)? = nil
//    ) {
//        self.animated = animated
//        self.completion = completion
//    }
//
//    public func perform(
//        to screens: [ScreenRoutable],
//        from fromScreen: ScreenRoutable
//    ) {
//        if screens.isEmpty { return }
//
//        guard let navigationContainer =
//                fromScreen as? UINavigationController ?? fromScreen.navigationController
//        else { return }
//
//        prepareForTransition(to: screens, from: fromScreen)
//
//        if navigationContainer.viewControllers.isEmpty {
//            navigationContainer.setViewControllers(screens, animated: false, completion: completeTransition)
//        } else {
//            navigationContainer.setViewControllers(screens, animated: animated, completion: completeTransition)
//        }
//    }
//}
//
//extension UINavigationController {
//    public func setViewControllers(
//        _ viewControllers: [UIViewController],
//        animated: Bool,
//        completion: (() -> Void)?
//    ) {
//        setViewControllers(viewControllers, animated: animated)
//        completeTransition(completion, animated: animated)
//    }
//
//    public func pushViewController(
//        _ screen: UIViewController,
//        animated: Bool,
//        completion: (() -> Void)?
//    ) {
//        pushViewController(screen, animated: animated)
//        completeTransition(completion, animated: animated)
//    }
//
//    public func popViewController(
//        animated: Bool,
//        completion: (() -> Void)?
//    ) -> UIViewController? {
//        let poppedScreen = popViewController(animated: animated)
//        completeTransition(completion, animated: animated)
//        return poppedScreen
//    }
//
//    public func popToViewController(
//        _ viewController: UIViewController,
//        animated: Bool,
//        completion: (() -> Void)?
//    ) -> [UIViewController]? {
//        let poppedScreens = popToViewController(viewController, animated: animated)
//        completeTransition(completion, animated: animated)
//        return poppedScreens
//    }
//}
//
//extension UINavigationController {
//    private func completeTransition(
//        _ completion: (() -> Void)?,
//        animated: Bool
//    ) {
//        if animated,
//           let transitionCoordinator = transitionCoordinator {
//            transitionCoordinator.animate(alongsideTransition: nil) { _ in
//                completion?()
//            }
//        } else {
//            completion?()
//        }
//    }
//}
