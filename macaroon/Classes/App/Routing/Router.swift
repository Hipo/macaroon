// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Router: AnyObject {
    associatedtype SomeFlow: Flow
    associatedtype SomePath: Path

    typealias SomeRoute = Route<SomeFlow, SomePath>

    /// <note>
    /// Knowing the visible flow helps if the visible screen is a system or a service screen.
    var visibleFlow: SomeFlow! { get set }

    /// <warning>
    /// The router depends on `visibleScreen` to navigate to the routes.
    var visibleScreen: UIViewController! { get set }

    var window: UIWindow? { get }
    var rootContainer: UIViewController { get }

    func makeNavigationContainer() -> UINavigationController

    /// <warning>
    /// Every app determines the transition for its flows. This method just returns the transition,
    /// not perform it.
    func makeTransition(to flow: SomeFlow) -> Transition?
}

extension Router {
    public var rootContainer: UIViewController {
        guard let currentRootContainer = window?.rootViewController else {
            mc_crash(
                .rootContainerNotFound
            )
        }

        return currentRootContainer
    }
}

extension Router {
    public func makeScreen<T: ScreenRoutable>(
        _ path: SomePath
    ) -> T {
        guard let screen = path.build() as? T else {
            mc_crash(
                .screenNotFound
            )
        }

        screen.pathIdentifier = path.identifier

        return screen
    }
}

extension Router {
    public func navigate(
        _ route: SomeRoute...,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        if route.isEmpty {
            return
        }

        var navigate: (() -> Void)?
        var navigateToNext: () -> Void = {
            completion?()
        }

        route
            .reversed()
            .forEach { subroute in
                let navigateToSubroute: () -> Void = {
                    let navigateToEnd = {
                        self.navigateToEnd(
                            subroute,
                            animated: animated,
                            completion: navigateToNext
                        )
                    }

                    if subroute.start == .current {
                        navigateToEnd()
                    } else {
                        self.navigateToStart(
                            subroute,
                            animated: animated,
                            completion: navigateToEnd
                        )
                    }
                }

                /// <note>
                /// Combine the serial navigations for the last subroute.
                if route.first == subroute {
                    navigate = navigateToSubroute
                } else {
                    navigateToNext = navigateToSubroute
                }
            }

        navigate?()
    }

    private func navigateToStart(
        _ subroute: SomeRoute,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        let flow = subroute.start
        let finishTransition = {
            self.visibleFlow = flow
            self.visibleScreen = self.findVisibleScreen()

            if let vs = self.visibleScreen as? ScreenRoutable {
                vs.flowIdentifier = flow.identifier
            }

            completion()
        }

        guard var flowTransition =
                self.makeTransition(
                    to: flow
                )
        else {
            finishTransition()
            return
        }

        flowTransition.completion = finishTransition
        flowTransition.perform(
            animated: animated
        )
    }

    private func navigateToEnd(
        _ subroute: SomeRoute,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        switch subroute.end {
        case .existing(let existingPath):
            navigate(
                to: existingPath,
                animated: animated,
                completion: completion
            )
        case .new(let newPaths):
            navigate(
                to: newPaths,
                transitionStyle: subroute.transitionStyle,
                animated: animated,
                completion: completion
            )
        }
    }

    private func navigate(
        to existingPath: ExistingPath,
        animated: Bool,
        completion: () -> Void
    ) {
        switch existingPath {
        case .initial:
            var bottommostPresentingScreen = visibleScreen

            exit: while let previousPresentingScreen = bottommostPresentingScreen!.presentingViewController {
                switch previousPresentingScreen {
                case let previousPresentingNavigationContainer as UINavigationController:
                    for screen in previousPresentingNavigationContainer.viewControllers {
                        if let configurableScreen = screen as? ScreenRoutable,
                           SomeFlow.instance(configurableScreen.flowIdentifier) == visibleFlow {
                            
                        }
                    }
                default:
                    break
                }
            }
        case .last:
            completion()
        case .interim(let aScreen):
            break
        }
    }

    private func navigate(
        to newPaths: [SomePath],
        transitionStyle: SomeRoute.TransitionStyle,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        let destination: [ScreenRoutable] = newPaths.map {
            let screen = $0.build()
            screen.flowIdentifier = visibleFlow.identifier
            screen.pathIdentifier = $0.identifier
            return screen
        }
        let transitionCompletion = { [unowned self] in
            self.visibleScreen = destination.last
            completion()
        }
        let transition =
            makeTransition(
                to: destination,
                transitionStyle: transitionStyle,
                completion: transitionCompletion
            )

        transition?.perform(
            animated: animated
        )
    }

    private func makeTransition(
        to destination: [UIViewController],
        transitionStyle: SomeRoute.TransitionStyle,
        completion: @escaping () -> Void
    ) -> Transition? {
        switch transitionStyle {
        /// <warning>
        /// It must not be used for the transitions for the new screens.
        case .existing:
            return nil
        case .next:
            return PushTransition(
                source: visibleScreen,
                destination: destination,
                completion: completion
            )
        case .stack:
            return StackTransition(
                source: visibleScreen,
                destination: destination,
                completion: completion
            )
        case .modal:
            return ModalTransition(
                source: visibleScreen,
                destination: destination,
                navigationContainer: makeNavigationContainer(),
                completion: completion
            )
        case .builtInModal(let modalPresentationStyle, let modalTransitionStyle):
            return BuiltInModalTransition(
                source: visibleScreen,
                destination: destination,
                navigationContainer: makeNavigationContainer(),
                modalPresentationStyle: modalPresentationStyle,
                modalTransitionStyle: modalTransitionStyle,
                completion: completion
            )
        case .customModal(let transitioningDelegate):
            return CustomModalTransition(
                source: visibleScreen,
                destination: destination,
                navigationContainer: makeNavigationContainer(),
                transitioningDelegate: transitioningDelegate,
                completion: completion
            )
        }
    }
}

extension Router {
    public func popVisibleScreen(
        animated: Bool = true
    ) {
        guard let navigationContainer = visibleScreen.navigationController else {
            return
        }

        if navigationContainer.viewControllers.count < 2 {
            return
        }

        navigationContainer.popViewController(
            animated: animated) {
            [unowned self] in

            self.visibleScreen =
                self.findVisibleScreen(
                    in: navigationContainer
                )

            if let vs = self.visibleScreen as? ScreenRoutable {
                self.visibleFlow = .instance(vs.flowIdentifier)
            }
        }
    }

    public func dismissVisibleScreen(
        animated: Bool = true
    ) {
        guard let presentingScreen = visibleScreen.presentingViewController else {
            return
        }

        presentingScreen.dismiss(
            animated: animated
        ) { [unowned self] in

            self.visibleScreen = presentingScreen

            if let vs = self.visibleScreen as? ScreenRoutable {
                self.visibleFlow = .instance(vs.flowIdentifier)
            }
        }
    }
}

extension Router {
    public func findVisibleScreen(
        over screen: UIViewController? = nil
    ) -> UIViewController {
        /// <warning>
        /// It is useless at the moment the app doesn't have a root container yet.
        if screen == nil &&
           rootContainer == nil {
            mc_crash(
                .screenNotFound
            )
        }

        var topmostPresentedScreen =
            findVisibleScreen(
                presentedBy: screen ?? rootContainer
            )

        switch topmostPresentedScreen {
        case let navigationContainer as UINavigationController:
            return findVisibleScreen(
                in: navigationContainer
            )
        case let tabbedContainer as TabbedContainer:
            return findVisibleScreen(
                in: tabbedContainer
            )
        default:
            return topmostPresentedScreen
        }
    }

    public func findVisibleScreen(
        presentedBy screen: UIViewController
    ) -> UIViewController {
        var topmostPresentedScreen = screen

        while let nextPresentedScreen = topmostPresentedScreen.presentedViewController {
            topmostPresentedScreen = nextPresentedScreen
        }
        return topmostPresentedScreen
    }

    public func findVisibleScreen(
        in navigationContainer: UINavigationController
    ) -> UIViewController {
        return navigationContainer.viewControllers.last ?? navigationContainer
    }

    public func findVisibleScreen(
        in tabbedContainer: TabbedContainer
    ) -> UIViewController {
        return tabbedContainer.selectedScreen ?? tabbedContainer
    }
}
