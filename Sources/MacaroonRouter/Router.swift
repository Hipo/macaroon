// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import MacaroonUtils
import UIKit

public protocol Router: AnyObject {
    /// <note>
    /// Knowing the visible flow helps if the visible screen is a system or a service screen.
    var visibleFlow: Flow! { get set }

    /// <warning>
    /// The router depends on `visibleScreen` to navigate to the routes.
    var visibleScreen: UIViewController! { get set }

    var window: UIWindow? { get }
    var rootContainer: UIViewController { get }

    func makeNavigationContainer() -> UINavigationController
}

extension Router {
    public var rootContainer: UIViewController {
        guard let currentRootContainer = window?.rootViewController else {
            crash("Root container not found")
        }

        return currentRootContainer
    }
}

extension Router {
    public func makeTransition(
        _ flow: Flow
    ) -> Transition? {
        return flow.build?(self)
    }
    
    public func makeScreen(
        _ path: Path
    ) -> ScreenRoutable {
        let screen = path.build()
        screen.pathIdentifier = path.identifier
        return screen
    }

    public func makeScreen(
        _ path: Path,
        containedIn parent: ScreenRoutable
    ) -> ScreenRoutable {
        let screen = makeScreen(path)
        screen.flowIdentifier = parent.flowIdentifier
        return screen
    }
}

extension Router {
    public func navigate(
        _ route: Route...,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let navigation =
            makeNavigation(
                route,
                animated: animated
            ) {
                completion?()
            }

        navigation()
    }

    func makeNavigation(
        _ subroute: [Route],
        animated: Bool,
        completion: @escaping () -> Void
    ) -> () -> Void {
        guard let nextSubroute = subroute.last else {
            return completion
        }

        return makeNavigation(
            subroute.dropLast(),
            animated: animated
        ) { [weak self] in
            guard let self = self else { return }
            
            guard let nextFlow = nextSubroute.flow else {
                self.navigateToDestination(
                    nextSubroute,
                    animated: animated,
                    completion: completion
                )

                return
            }
            
            if !self.shouldNavigateToFlow(nextFlow) {
                self.navigateToDestination(
                    nextSubroute,
                    animated: animated,
                    completion: completion
                )

                return
            }
            
            self.navigateToFlow(
                nextFlow,
                animated: animated
            ) { [weak self] in
                guard let self = self else { return }
                    
                self.navigateToDestination(
                    nextSubroute,
                    animated: animated,
                    completion: completion
                )
            }
        }
    }

    private func navigateToFlow(
        _ flow: Flow,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        let transitionCompletion = { [weak self] in
            guard let self = self else { return }

            self.visibleFlow = flow
            self.visibleScreen = self.findVisibleScreen()

            if let vs = self.visibleScreen as? ScreenRoutable {
                vs.flowIdentifier = flow.identifier
            }

            completion()
        }
        
        if !shouldNavigateToFlow(flow) {
            transitionCompletion()
            return
        }
        
        guard var flowTransition = makeTransition(flow) else {
            transitionCompletion()
            return
        }

        flowTransition.completion = transitionCompletion
        flowTransition.perform(
            animated: animated
        )
    }

    private func navigateToDestination(
        _ subroute: Route,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        switch subroute.destination {
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
        case .override(let existingScreen, let newPaths):
            navigate(
                to: newPaths,
                attachedTo: existingScreen,
                animated: animated,
                completion: completion
            )
        }
    }

    private func navigate(
        to existingPath: ExistingPath,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        switch existingPath {
        case .initial:
            guard let firstScreenInVisibleFlow = findFirstScreenInVisibleFlow() else {
                completion()
                return
            }

            navigate(
                to: firstScreenInVisibleFlow,
                animated: animated,
                completion: completion
            )
        case .last:
            completion()
        case .interim(let aScreen):
            navigate(
                to: aScreen,
                animated: animated,
                completion: completion
            )
        }
    }

    private func navigate(
        to existingScreen: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        let isPresenting = existingScreen.presentedViewController != nil
        let transitionCompletion = {
            [weak self] in
            guard let self = self else { return }

            self.visibleScreen = existingScreen

            if isPresenting,
               let anExistingScreen = existingScreen as? Screen {
                anExistingScreen.viewDidAppearAfterDismiss()
            }

            completion()
        }

        if let tabbedContainer = existingScreen.parent as? TabbedContainer {
            if isPresenting {
                existingScreen.dismiss(
                    animated: animated
                )
            }

            if let navigationContainer = existingScreen.navigationController,
               navigationContainer.viewControllers.last != tabbedContainer {
                navigationContainer.popToViewController(
                    tabbedContainer,
                    animated: !isPresenting && animated
                ) {
                    tabbedContainer.selectedScreen = existingScreen
                    transitionCompletion()
                }
            } else {
                tabbedContainer.selectedScreen = existingScreen
                transitionCompletion()
            }

            return
        }

        if let navigationContainer = existingScreen.navigationController,
           navigationContainer.viewControllers.last != existingScreen {
            if isPresenting {
                existingScreen.dismiss(
                    animated: animated
                )
            }

            navigationContainer.popToViewController(
                existingScreen,
                animated: !isPresenting && animated,
                completion: transitionCompletion
            )

            return
        }

        if isPresenting {
            existingScreen.dismiss(
                animated: animated,
                completion: transitionCompletion
            )

            return
        }

        transitionCompletion()
    }

    private func navigate(
        to newPaths: [Path],
        transitionStyle: Route.TransitionStyle,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        let destination = makeDestination(
            newPaths
        )
        let transitionCompletion = {
            [weak self] in
            guard let self = self else { return }

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

    private func makeDestination(
        _ paths: [Path]
    ) -> [ScreenRoutable] {
        return paths.map {
            let screen = $0.build()
            screen.flowIdentifier = visibleFlow.identifier
            screen.pathIdentifier = $0.identifier
            return screen
        }
    }

    private func makeTransition(
        to destination: [UIViewController],
        transitionStyle: Route.TransitionStyle,
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
                overridesFullStack: true,
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
        case .customModal(let transitioningDelegate, let isContainedInNavigationContainer):
            return CustomModalTransition(
                source: visibleScreen,
                destination: destination,
                navigationContainer: isContainedInNavigationContainer ? makeNavigationContainer() : nil,
                transitioningDelegate: transitioningDelegate,
                completion: completion
            )
        }
    }

    private func navigate(
        to newPaths: [Path],
        attachedTo existingScreen: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        let destination = makeDestination(
            newPaths
        )
        let transitionCompletion = {
            [weak self] in
            guard let self = self else { return }

            self.visibleScreen = destination.last
            completion()
        }

        let isPresenting = existingScreen.presentedViewController != nil

        if isPresenting {
            existingScreen.dismiss(
                animated: animated
            )
        }

        let transition =
            StackTransition(
                source: existingScreen,
                destination: destination,
                overridesFullStack: false,
                completion: transitionCompletion
            )

        transition.perform(
            animated: !isPresenting && animated
        )
    }
}

extension Router {
    public func navigateToInAppSafari(
        _ url: URL
    ) {
        let screen = InAppSafariScreen(url: url)
        screen.flowIdentifier = visibleFlow.identifier
        screen.pathIdentifier = url.path

        visibleScreen.present(
            screen,
            animated: true
        ) { [unowned self] in

            self.visibleScreen = screen
        }
    }
    
    public func navigateToSafari(
        _ url: URL
    ) {
        if !UIApplication.shared.canOpenURL(
            url
        ) {
            return
        }

        UIApplication.shared.open(
            url,
            options: [:],
            completionHandler: nil
        )
    }
}

extension Router {
    public func popVisibleScreen(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        popScreen(
            visibleScreen,
            animated: animated,
            completion: completion
        )
    }
    
    public func popScreen(
        _ screen: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard let navigationContainer = visibleScreen.navigationController else {
            return
        }
        
        let screensInStack = navigationContainer.viewControllers
        let previousIndex = screensInStack.lastIndex.unwrap { $0 - 1 }
        
        guard let previousScreen = screensInStack[safe: previousIndex] as? ScreenRoutable else {
            return
        }

        navigate(
            .path(previousScreen),
            animated: animated,
            completion: completion
        )
    }

    public func dismissVisibleScreen(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        dismissScreen(
            visibleScreen,
            animated: animated,
            completion: completion
        )
    }
    
    public func dismissScreen(
        _ screen: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard
            let presentingScreen = screen.presentingViewController,
            let presentingVisibleScreen = findVisibleScreen(in: presentingScreen) as? ScreenRoutable
        else {
            return
        }

        navigate(
            .path(presentingVisibleScreen),
            animated: animated,
            completion: completion
        )
    }
}

/// <warning>
/// Normally, the visible screen is automatically updated by the router when a screen is
/// navigated programmatically. But, the interactive transitions(pop or dismiss or tab selection)
/// prevent this, so it should be set manually after returning the previous screen.
extension Router {
    public func updateVisibleScreenAfterViewDidAppear(
        _ screen: UIViewController
    ) {
        defer {
            if let aVisibleScreen = visibleScreen as? ScreenRoutable,
               !aVisibleScreen.flowIdentifier.isEmpty {
                visibleFlow = AnyFlow(aVisibleScreen.flowIdentifier)
            }
        }

        guard let parent = screen.parent else {
            visibleScreen = screen
            return
        }

        if parent is UINavigationController ||
           parent is TabbedContainer {
            visibleScreen = screen
            return
        }

        visibleScreen = parent
    }
}

extension Router {
    public func shouldNavigateToFlow(
        _ flow: Flow
    ) -> Bool {
        if visibleFlow == nil {
            return true
        }
        
        return !flow.equals(to: visibleFlow)
    }
}

extension Router {
    public func findVisibleScreen(
        over screen: UIViewController? = nil
    ) -> UIViewController {
        let topmostPresentedScreen =
            findVisibleScreen(
                presentedBy: screen ?? rootContainer
            )

        return findVisibleScreen(
            in: topmostPresentedScreen
        )
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
        in screen: UIViewController
    ) -> UIViewController {
        switch screen {
        case let navigationContainer as UINavigationController:
            return findVisibleScreen(
                in: navigationContainer
            )
        case let tabbedContainer as TabbedContainer:
            return findVisibleScreen(
                in: tabbedContainer
            )
        default:
            return screen
        }
    }

    public func findVisibleScreen(
        in navigationContainer: UINavigationController
    ) -> UIViewController {
        return navigationContainer.viewControllers.last ?? navigationContainer
    }

    public func findVisibleScreen(
        in tabbedContainer: TabbedContainer
    ) -> UIViewController {
        guard let selectedScreen = tabbedContainer.selectedScreen else {
            return tabbedContainer
        }

        switch selectedScreen {
        case let navigationContainer as UINavigationController:
            return findVisibleScreen(
                in: navigationContainer
            )
        default:
            return selectedScreen
        }
    }
}

extension Router {
    private func findFirstScreenInVisibleFlow() -> UIViewController? {
        var firstScreenInVisibleFlow =
            findFirstScreenInVisibleFlow(
                appearedWithinHierarchyOf: visibleScreen.parent ?? visibleScreen
            )

        while let presentingFirstScreenInVisibleFlow =
                findFirstScreenInVisibleFlow(
                    appearedWithinHierarchyOf: firstScreenInVisibleFlow?.presentingViewController
                ) {
            firstScreenInVisibleFlow = presentingFirstScreenInVisibleFlow
        }

        return firstScreenInVisibleFlow
    }

    private func findFirstScreenInVisibleFlow(
        appearedWithinHierarchyOf screen: UIViewController?
    ) -> UIViewController? {
        switch screen {
        case let navigationContainer as UINavigationController:
            return navigationContainer.viewControllers.first {
                ($0 as? ScreenRoutable)?.flowIdentifier == visibleFlow.identifier
            }
        case let tabbedContainer as TabbedContainer:
            return tabbedContainer.screens.first {
                findFirstScreenInVisibleFlow(
                    appearedWithinHierarchyOf: $0
                ) != nil
            }
        case let someScreen as ScreenRoutable:
            return someScreen.flowIdentifier == visibleFlow.identifier ? someScreen : nil
        default: return nil
        }
    }
}
