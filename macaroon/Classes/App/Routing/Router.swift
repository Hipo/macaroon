// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

/// <todo> Add a method to check the path is something that is the same content on the current screen.
/// This shoulg be optional because we wanto to force the same screen sequentially.
public protocol Router: AnyObject {
    associatedtype SomeRootContainer: RootContainer
    associatedtype SomeFlow: Flow
    associatedtype SomePath: Path

    var rootContainer: SomeRootContainer! { get }
    /// <warning>
    /// The router depends on `visibleScreen` to navigate to the routes.
    var visibleScreen: UIViewController! { get set }

    /// <warning>
    /// Every app determines the transition for its flows. This method just returns the transition,
    /// not perform it.
    func makeTransition(to flow: SomeFlow) -> Transition

//    func embedInNavigationScreen(_ hhroot: UIViewController) -> UINavigationController
}

extension Router {
    public func makeScreen<T: UIViewController>(_ path: SomePath) -> T {
        if let screen = path.build() as? T {
            return screen
        }
        mc_crash(.screenNotFound)
    }
}

extension Router {
    public func navigate(
        _ route: Route<SomeFlow, SomePath>...,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        if route.isEmpty { return }

        var dispatch: () -> Void = { }

        route.reversed().forEach { subroute in
        }

        dispatch()
    }
}

extension Router {
    public func findVisibleScreen(over screen: UIViewController? = nil) -> UIViewController {
        /// <warning>
        /// It is useless at the moment the app doesn't have a root container yet.
        if screen == nil && rootContainer == nil {
            mc_crash(.screenNotFound)
        }

        var topmostPresentedScreen = findVisibleScreen(presentedBy: screen ?? rootContainer)

        switch topmostPresentedScreen {
        case let navigationContainer as UINavigationController:
            return findVisibleScreen(in: navigationContainer)
        case let tabbedContainer as TabbedContainer:
            return findVisibleScreen(in: tabbedContainer)
        default:
            return topmostPresentedScreen
        }
    }

    public func findVisibleScreen(presentedBy screen: UIViewController) -> UIViewController {
        var topmostPresentedScreen = screen

        while let nextPresentedScreen = topmostPresentedScreen.presentedViewController {
            topmostPresentedScreen = nextPresentedScreen
        }
        return topmostPresentedScreen
    }

    public func findVisibleScreen(in navigationContainer: UINavigationController) -> UIViewController {
        return navigationContainer.viewControllers.last ?? navigationContainer
    }

    public func findVisibleScreen(in tabbedContainer: TabbedContainer) -> UIViewController {
        return tabbedContainer.selectedScreen ?? tabbedContainer
    }
}

//    func presentScreens(_ screens: [UIViewController], from source: UIViewController, by transition: RouteTransition.Open.Presentation = .default, animated: Bool = true, onCompleted handler: TransitionCompletionHandler? = nil) {
//        if let configurableSource = source as? StatusBarConfigurable, configurableSource.isStatusBarHidden,
//           let configurableScreen = screens.last as? StatusBarConfigurable {
//            configurableScreen.hidesStatusBarOnPresented = true
//            configurableScreen.isStatusBarHidden = true
//        }
//
//        let navigationContainer: UINavigationController
//        if screens.count > 1 {
//            navigationContainer = embedInNavigationScreen(screens[0])
//            navigationContainer.setViewControllers(screens, animated: false)
//        } else {
//           navigationContainer = screens[0] as? UINavigationController ?? embedInNavigationScreen(screens[0])
//        }
//
//        switch transition {
//        case .`default`:
//            break
//        case .modal(let presentationStyle, let transitionStyle):
//            navigationContainer.modalPresentationStyle = presentationStyle
//
//            if let someTransitionStyle = transitionStyle {
//                navigationContainer.modalTransitionStyle = someTransitionStyle
//            }
//        case .custom(let transitioningDelegate):
//            navigationContainer.modalPresentationStyle = .custom
//            navigationContainer.modalPresentationCapturesStatusBarAppearance = true
//            navigationContainer.transitioningDelegate = transitioningDelegate
//        }
//        source.present(navigationContainer, animated: animated) {
//            if !transition.isFullScreen {
//                navigationContainer.presentationController?.delegate = source as? UIAdaptivePresentationControllerDelegate
//            }
//            handler?()
//        }
//    }
//
//    func dismisListScreen(_ screen: UIViewController, animated: Bool = true, onCompleted handler: TransitionCompletionHandler? = nil) {
//        screen.presentingViewController?.dismiss(animated: animated, completion: handler)
//    }
//}
