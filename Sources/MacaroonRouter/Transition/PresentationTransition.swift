// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public protocol PresentationTransition: Transition {
    var source: UIViewController? { get set }
    var navigationContainer: UINavigationController? { get set }
}

extension PresentationTransition {
    func prepareForTransition(
        from source: UIViewController,
        to destination: [UIViewController],
        in navigationContainer: UINavigationController?
    ) -> UIViewController {
        if
            let lastDestination = destination.last as? StatusBarConfigurable,
            let source = source as? StatusBarConfigurable,
            source.statusBarHidden {
            lastDestination.hidesStatusBarOnPresented = true
            lastDestination.statusBarHidden = true
        }

        guard let navigationContainer = navigationContainer else {
            return destination[0]
        }

        navigationContainer.setViewControllers(
            destination,
            animated: false
        )
        return navigationContainer
    }

    func finishTransition(
        fullScreen: Bool,
        from source: UIViewController,
        to destination: UIViewController
    ) {
        if fullScreen {
            return
        }

        destination.presentationController?.delegate =
            source as? UIAdaptivePresentationControllerDelegate
    }
}

public struct ModalTransition: PresentationTransition {
    public var source: UIViewController?
    public var destination: [UIViewController]
    public var navigationContainer: UINavigationController?
    public var completion: Completion?

    public init(
        source: UIViewController?,
        destination: [UIViewController],
        navigationContainer: UINavigationController?,
        completion: Completion?
    ) {
        self.source = source
        self.destination = destination
        self.navigationContainer = navigationContainer
        self.completion = completion
    }

    public func perform(
        animated: Bool
    ) {
        if destination.isEmpty {
            completion?()
            return
        }

        guard let source = source else {
            completion?()
            return
        }

        let presentedScreen =
            prepareForTransition(
                from: source,
                to: destination,
                in: navigationContainer
            )

        source.present(
            presentedScreen,
            animated: animated) {
            finishTransition(
                fullScreen: false,
                from: source,
                to: presentedScreen
            )

            completion?()
        }
    }
}

public struct BuiltInModalTransition: PresentationTransition {
    public var source: UIViewController?
    public var destination: [UIViewController]
    public var navigationContainer: UINavigationController?
    public var modalPresentationStyle: UIModalPresentationStyle
    public var modalTransitionStyle: UIModalTransitionStyle?
    public var completion: Completion?

    public init(
        source: UIViewController?,
        destination: [UIViewController],
        navigationContainer: UINavigationController?,
        modalPresentationStyle: UIModalPresentationStyle,
        modalTransitionStyle: UIModalTransitionStyle?,
        completion: Completion?
    ) {
        self.source = source
        self.destination = destination
        self.navigationContainer = navigationContainer
        self.modalPresentationStyle = modalPresentationStyle
        self.modalTransitionStyle = modalTransitionStyle
        self.completion = completion
    }

    public func perform(
        animated: Bool
    ) {
        if destination.isEmpty {
            completion?()
            return
        }

        guard let source = source else {
            completion?()
            return
        }

        let presentedScreen =
            prepareForTransition(
                from: source,
                to: destination,
                in: navigationContainer
            )
        presentedScreen.modalPresentationStyle = modalPresentationStyle

        if let modalTransitionStyle = modalTransitionStyle {
            presentedScreen.modalTransitionStyle = modalTransitionStyle
        }

        source.present(
            presentedScreen,
            animated: animated) {
            finishTransition(
                fullScreen: modalPresentationStyle == .fullScreen,
                from: source,
                to: presentedScreen
            )

            completion?()
        }
    }
}

public struct CustomModalTransition: PresentationTransition {
    public var source: UIViewController?
    public var destination: [UIViewController]
    public var navigationContainer: UINavigationController?
    public unowned var transitioningDelegate: UIViewControllerTransitioningDelegate
    public var completion: Completion?

    public init(
        source: UIViewController?,
        destination: [UIViewController],
        navigationContainer: UINavigationController?,
        transitioningDelegate: UIViewControllerTransitioningDelegate,
        completion: Completion?
    ) {
        self.source = source
        self.destination = destination
        self.navigationContainer = navigationContainer
        self.transitioningDelegate = transitioningDelegate
        self.completion = completion
    }

    public func perform(
        animated: Bool
    ) {
        if destination.isEmpty {
            completion?()
            return
        }

        guard let source = source else {
            completion?()
            return
        }

        let presentedScreen =
            prepareForTransition(
                from: source,
                to: destination,
                in: navigationContainer
            )
        presentedScreen.modalPresentationStyle = .custom
        presentedScreen.modalPresentationCapturesStatusBarAppearance = true
        presentedScreen.transitioningDelegate = transitioningDelegate

        source.present(
            presentedScreen,
            animated: animated) {
            finishTransition(
                fullScreen: false,
                from: source,
                to: presentedScreen
            )

            completion?()
        }
    }
}
