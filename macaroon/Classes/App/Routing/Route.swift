// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct Route<
    SomeFlow: Flow,
    SomePath: Path
>: Equatable {
    let identifier: String
    let start: Start
    let end: End
    let transitionStyle: TransitionStyle

    init(
        start: Start,
        end: End,
        transitionStyle: TransitionStyle
    ) {
        self.identifier = UUID().uuidString
        self.start = start
        self.end = end
        self.transitionStyle = transitionStyle
    }
}

extension Route {
    public static func flow(
        _ flow: SomeFlow,
        at existingPath: ExistingPath = .last
    ) -> Self {
        return .init(start: flow, end: .existing(existingPath), transitionStyle: .existing)
    }

    public static func path(
        _ aScreen: ScreenRoutable
    ) -> Self {
        return .flow(.instance(aScreen.flowIdentifier), at: .interim(aScreen))
    }

    public static func next(
        _ paths: SomePath...
    ) -> Self {
        return .init(start: .current, end: .new(paths), transitionStyle: .next)
    }

    public static func stack(
        _ paths: SomePath...
    ) -> Self {
        return .init(start: .current, end: .new(paths), transitionStyle: .stack)
    }

    public static func modal(
        _ paths: SomePath...
    ) -> Self {
        return .init(start: .current, end: .new(paths), transitionStyle: .modal)
    }

    public static func builtInModal(
        _ paths: SomePath...,
        modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
        modalTransitionStyle: UIModalTransitionStyle? = nil
    ) -> Self {
        return .init(
            start: .current,
            end: .new(paths),
            transitionStyle: .builtInModal(modalPresentationStyle, modalTransitionStyle)
        )
    }

    public static func customModal(
        _ paths: SomePath...,
        transitioningDelegate: UIViewControllerTransitioningDelegate
    ) -> Self {
        return .init(
            start: .current,
            end: .new(paths),
            transitionStyle: .customModal(transitioningDelegate)
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
    typealias Start = SomeFlow

    enum End {
        case existing(ExistingPath)
        case new([SomePath])
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
        case builtInModal(UIModalPresentationStyle, UIModalTransitionStyle?)
        case customModal(UIViewControllerTransitioningDelegate)
    }
}
