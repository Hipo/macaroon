// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol AppRouter: AnyObject, AppLaunchable, AppRouting {
    associatedtype SomeRootContainer: RootContainer where SomeRootContainer.SomeAppLaunchArgs == SomeAppLaunchArgs

    init(appLaunchArgs: SomeAppLaunchArgs)

    /// <note> It should be called once when it is set as the root view controller in window.
    func makeRootContainer() -> SomeRootContainer
    func makeNavigationContainer(_ root: UIViewController) -> UINavigationController
    func makeSplash() -> UIViewController

    func openAuthorizationFlow(by transition: AppRouterTransition.Open, animated: Bool, onCompleted handler: TransitionHandler?) -> UIViewController
    func openHomeFlow(animated: Bool, onCompleted handler: TransitionHandler?) -> UIViewController
}

extension AppRouter {
    public func openScreen<T: UIViewController>(_ destination: Destination, from source: UIViewController, by transition: AppRouterTransition.Open, animated: Bool = true, onCompleted handler: TransitionHandler? = nil) -> T {
        let screen: T = makeScreen(destination)

        switch transition {
        case .navigation(let navigation):
            pushScreen(screen, from: source, by: navigation, animated: animated, onCompleted: handler)
        case .presentation(let presentation):
            presentScreen(screen, from: source, by: presentation, animated: animated, onCompleted: handler)
        }
        return screen
    }

    public func closeScreen(_ screen: UIViewController, by transition: AppRouterTransition.Close, animated: Bool = true, onCompleted handler: TransitionHandler? = nil) {
        switch transition {
        case .navigation(let navigation):
            popScreen(screen, by: navigation, animated: animated, onCompleted: handler)
        case .presentation:
            dismissScreen(screen, animated: animated, onCompleted: handler)
        }
    }
}

extension AppRouter {
    public var rootContainer: SomeRootContainer {
        if let rootContainer = UIApplication.shared.keyWindow?.rootViewController as? SomeRootContainer {
            return rootContainer
        }
        mc_crash(.rootContainerNotMatch)
    }

    public func pushScreen(_ screen: UIViewController, from source: UIViewController, by transition: AppRouterTransition.Open.Navigation = .next, animated: Bool = true, onCompleted handler: TransitionHandler? = nil) {
        if let configurableSource = source as? StatusBarConfigurable,
           let configurableScreen = screen as? StatusBarConfigurable {
            let isStatusBarHidden = configurableSource.isStatusBarHidden

            configurableScreen.hidesStatusBarOnAppeared = isStatusBarHidden
            configurableScreen.isStatusBarHidden = isStatusBarHidden
        }
        switch transition {
        case .next:
            source.navigationController?.pushViewController(source, animated: animated)
        case .root:
            source.navigationController?.setViewControllers([source], animated: animated)
        }
        handler?()
    }

    public func presentScreen(_ screen: UIViewController, from source: UIViewController, by transition: AppRouterTransition.Open.Presentation = .default, animated: Bool = true, onCompleted handler: TransitionHandler? = nil) {
        if let configurableSource = source as? StatusBarConfigurable, configurableSource.isStatusBarHidden,
           let configurableScreen = screen as? StatusBarConfigurable {
            configurableScreen.hidesStatusBarOnPresented = true
            configurableScreen.isStatusBarHidden = true
        }

        let navigationContainer = makeNavigationContainer(screen)

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

        source.present(navigationContainer, animated: animated, completion: handler)
    }

    public func popScreen(_ screen: UIViewController, by transition: AppRouterTransition.Close.Navigation = .previous, animated: Bool = true, onCompleted handler: TransitionHandler? = nil) {
        switch transition {
        case .previous:
            screen.navigationController?.popViewController(animated: animated)
        case .root:
            screen.navigationController?.popToRootViewController(animated: animated)
        }
        handler?()
    }

    public func dismissScreen(_ screen: UIViewController, animated: Bool = true, onCompleted handler: TransitionHandler? = nil) {
        screen.presentingViewController?.dismiss(animated: animated, completion: handler)
    }
}

public protocol AppRouting {
    associatedtype Destination: AppRoutingDestination
    typealias TransitionHandler = () -> Void

    func openScreen<T: UIViewController>(_ destination: Destination, from source: UIViewController, by transition: AppRouterTransition.Open, animated: Bool, onCompleted handler: TransitionHandler?) -> T
    func closeScreen(_ screen: UIViewController, by transition: AppRouterTransition.Close, animated: Bool, onCompleted handler: TransitionHandler?)
    func makeScreen<T: UIViewController>(_ destination: Destination) -> T
}

public struct NoAppRouting: AppRouting {
    public typealias Destination = NoAppRoutingDestionation

    public func openScreen<T: UIViewController>(_ destination: Destination, from source: UIViewController, by transition: AppRouterTransition.Open, animated: Bool, onCompleted handler: TransitionHandler?) -> T {
        mc_crash(.routerNotFound)
    }

    public func closeScreen(_ screen: UIViewController, by transition: AppRouterTransition.Close, animated: Bool, onCompleted handler: TransitionHandler?) { }

    public func makeScreen<T: UIViewController>(_ destination: Destination) -> T {
        mc_crash(.routerNotFound)
    }
}

public protocol AppRoutingDestination { }

public struct NoAppRoutingDestionation: AppRoutingDestination { }

public enum AppRouterTransition {
    public enum Open {
        case navigation(Navigation)
        case presentation(Presentation)

        public enum Navigation {
            case next /// <note> `push`
            case root
        }

        public enum Presentation {
            case `default`
            case modal(UIModalPresentationStyle, UIModalTransitionStyle? = nil)
            case custom(UIViewControllerTransitioningDelegate)
        }
    }

    public enum Close {
        case navigation(Navigation)
        case presentation

        public enum Navigation {
            case previous
            case root
        }
    }
}
