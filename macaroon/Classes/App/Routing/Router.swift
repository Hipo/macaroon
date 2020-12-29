// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Router: AnyObject {
    typealias TransitionCompletionHandler = () -> Void

    associatedtype SomeRoute: Route

    func makeRootContainer() -> RootContainer
    func makeSplash() -> UIViewController
    func makeScreen<T: UIViewController>(_ route: SomeRoute) -> T

    func embedInNavigationScreen(_ root: UIViewController) -> UINavigationController
}

extension Router {
    @discardableResult
    public func openRoute<T: UIViewController>(_ route: SomeRoute, from source: UIViewController, by transition: RouteTransition.Open, animated: Bool = true, onCompleted handler: TransitionCompletionHandler? = nil) -> T {
        let screen: T = makeScreen(route)

        switch transition {
        case .navigation(let navigation):
            pushScreens([screen], from: source, by: navigation, animated: animated, onCompleted: handler)
        case .presentation(let presentation):
            presentScreens([screen], from: source, by: presentation, animated: animated, onCompleted: handler)
        }
        return screen
    }

    @discardableResult
    public func openRoutes(_ routes: [SomeRoute], from source: UIViewController, by transition: RouteTransition.Open, animated: Bool = true, onCompleted handler: TransitionCompletionHandler? = nil) -> [UIViewController] {
        let screens = routes.map(makeScreen)

        switch transition {
        case .navigation(let navigation):
            pushScreens(screens, from: source, by: navigation, animated: animated, onCompleted: handler)
        case .presentation(let presentation):
            presentScreens(screens, from: source, by: presentation, animated: animated, onCompleted: handler)
        }
        return screens
    }

    public func closeScreen(_ screen: UIViewController, by transition: RouteTransition.Close, animated: Bool = true, onCompleted handler: TransitionCompletionHandler? = nil) {
        switch transition {
        case .navigation(let navigation):
            popScreen(screen, by: navigation, animated: animated, onCompleted: handler)
        case .presentation:
            dismisListScreen(screen, animated: animated, onCompleted: handler)
        }
    }
}

extension Router {
    func pushScreens(_ screens: [UIViewController], from source: UIViewController, by transition: RouteTransition.Open.Navigation = .next, animated: Bool = true, onCompleted handler: TransitionCompletionHandler? = nil) {
        if let configurableSource = source as? StatusBarConfigurable,
            let configurableScreen = screens.last as? StatusBarConfigurable {
            let isStatusBarHidden = configurableSource.isStatusBarHidden

            configurableScreen.hidesStatusBarOnAppeared = isStatusBarHidden
            configurableScreen.isStatusBarHidden = isStatusBarHidden
        }
        let navigationContainer = source as? UINavigationController ?? source.navigationController

        if screens.count > 1 {
            navigationContainer?.setViewControllers(screens, animated: animated)
        } else {
            switch transition {
            case .next:
                navigationContainer?.pushViewController(screens[0], animated: animated)
            case .root:
                navigationContainer?.setViewControllers([screens[0]], animated: animated)
            }
        }
        handler?()
    }

    func presentScreens(_ screens: [UIViewController], from source: UIViewController, by transition: RouteTransition.Open.Presentation = .default, animated: Bool = true, onCompleted handler: TransitionCompletionHandler? = nil) {
        if let configurableSource = source as? StatusBarConfigurable, configurableSource.isStatusBarHidden,
           let configurableScreen = screens.last as? StatusBarConfigurable {
            configurableScreen.hidesStatusBarOnPresented = true
            configurableScreen.isStatusBarHidden = true
        }

        let navigationContainer: UINavigationController
        if screens.count > 1 {
            navigationContainer = embedInNavigationScreen(screens[0])
            navigationContainer.setViewControllers(screens, animated: false)
        } else {
           navigationContainer = screens[0] as? UINavigationController ?? embedInNavigationScreen(screens[0])
        }

        switch transition {
        case .`default`:
            break
        case .modal(let presentationStyle, let transitionStyle):
            navigationContainer.modalPresentationStyle = presentationStyle

            if let someTransitionStyle = transitionStyle {
                navigationContainer.modalTransitionStyle = someTransitionStyle
            }
        case .custom(let transitioningDelegate):
            navigationContainer.modalPresentationStyle = .custom
            navigationContainer.modalPresentationCapturesStatusBarAppearance = true
            navigationContainer.transitioningDelegate = transitioningDelegate
        }
        source.present(navigationContainer, animated: animated) {
            if !transition.isFullScreen {
                navigationContainer.presentationController?.delegate = source as? UIAdaptivePresentationControllerDelegate
            }
            handler?()
        }
    }

    func popScreen(_ screen: UIViewController, by transition: RouteTransition.Close.Navigation = .previous, animated: Bool = true, onCompleted handler: TransitionCompletionHandler? = nil) {
        let navigationContainer = screen as? UINavigationController ?? screen.navigationController

        switch transition {
        case .previous:
            navigationContainer?.popViewController(animated: animated)
        case .root:
            navigationContainer?.popToRootViewController(animated: animated)
        }
        handler?()
    }

    func dismisListScreen(_ screen: UIViewController, animated: Bool = true, onCompleted handler: TransitionCompletionHandler? = nil) {
        screen.presentingViewController?.dismiss(animated: animated, completion: handler)
    }
}

public enum RouteTransition {
    public enum Open {
        case navigation(Navigation = .next)
        case presentation(Presentation = .default)

        public enum Navigation {
            case next
            case root
        }

        public enum Presentation {
            case `default`
            case modal(UIModalPresentationStyle, UIModalTransitionStyle? = nil)
            case custom(UIViewControllerTransitioningDelegate)

            public var isFullScreen: Bool {
                switch self {
                case .modal(let presentationStyle, _):
                    return presentationStyle == .fullScreen
                default:
                    return false
                }
            }
        }
    }

    public enum Close {
        case navigation(Navigation = .previous)
        case presentation

        public enum Navigation {
            case previous
            case root
        }
    }
}
