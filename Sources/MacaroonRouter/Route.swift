// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public struct Route {
    let identifier: String
    let flow: Flow? /// nil = current flow
    let destination: Destination
    let transitionStyle: TransitionStyle

    init(
        flow: Flow?,
        destination: Destination,
        transitionStyle: TransitionStyle
    ) {
        self.identifier = UUID().uuidString
        self.flow = flow
        self.destination = destination
        self.transitionStyle = transitionStyle
    }
}

extension Route {
    public static func flow(
        _ flow: Flow,
        at existingPath: ExistingPath = .last
    ) -> Self {
        return .init(flow: flow, destination: .existing(existingPath), transitionStyle: .existing)
    }

    public static func path(
        _ existingScreen: ScreenRoutable
    ) -> Self {
        return .flow(AnyFlow(existingScreen.flowIdentifier), at: .interim(existingScreen))
    }

    public static func next(
        _ paths: Path...
    ) -> Self {
        return .init(flow: nil, destination: .new(paths), transitionStyle: .next)
    }

    public static func stack(
        _ paths: Path...
    ) -> Self {
        return .init(flow: nil, destination: .new(paths), transitionStyle: .stack)
    }

    public static func stack(
        _ paths: Path...,
        attachedTo existingScreen: ScreenRoutable
    ) -> Self {
        return .init(
            flow: AnyFlow(existingScreen.flowIdentifier),
            destination: .override(existingScreen, paths),
            transitionStyle: .stack
        )
    }

    public static func modal(
        _ paths: Path...
    ) -> Self {
        return .init(flow: nil, destination: .new(paths), transitionStyle: .modal)
    }

    public static func builtInModal(
        _ paths: Path...,
        modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
        modalTransitionStyle: UIModalTransitionStyle? = nil
    ) -> Self {
        return .init(
            flow: nil,
            destination: .new(paths),
            transitionStyle: .builtInModal(
                presentation: modalPresentationStyle,
                transition: modalTransitionStyle
            )
        )
    }

    public static func customModal(
        _ paths: Path...,
        transitioningDelegate: UIViewControllerTransitioningDelegate,
        containedInNavigationContainer isInNavContainer: Bool = true
    ) -> Self {
        return .init(
            flow: nil,
            destination: .new(paths),
            transitionStyle: .customModal(
                transitioningDelegate: transitioningDelegate,
                containedInNavigationContainer: isInNavContainer
            )
        )
    }
}

extension Route {
    public static func ==(
        lhs: Self,
        rhs: Self
    ) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension Route {
    enum Destination {
        case existing(ExistingPath)
        case new([Path])
        case override(ScreenRoutable, [Path])
    }

    enum TransitionStyle {
        /// <mark>
        /// A backward transition to an existing path, or an application flow.
        case existing

        /// <mark>
        /// A forward transition to a new path.
        case next
        case stack
        case modal
        case builtInModal(
            presentation: UIModalPresentationStyle,
            transition: UIModalTransitionStyle?
        )
        case customModal(
            transitioningDelegate: UIViewControllerTransitioningDelegate,
            containedInNavigationContainer: Bool
        )
    }
}
