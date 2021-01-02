// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct Route<SomeFlow: Flow, SomePath: Path> {
    public var transition: Transition

    public let flow: SomeFlow
    public let paths: [SomePath]
    public let anchorPath: AnchorPath

    public init(
        flow: SomeFlow,
        paths: [SomePath],
        attachedTo anchorPath: AnchorPath,
        transition: Transition
    ) {
        self.flow = flow
        self.paths = paths
        self.anchorPath = anchorPath
        self.transition = transition
    }
}

extension Route {
    public static func flow(
        _ flow: SomeFlow,
        attachedTo anchorPath: AnchorPath = .current,
        transition: SelfTransition = SelfTransition()
    ) -> Self {
        return Route(flow: flow, paths: [], attachedTo: anchorPath, transition: transition)
    }

//    public static func path(
//        _ aScreen: ScreenRoutable,
//        transition: SelfTransition = SelfTransition()
//    ) -> Self {
//        guard
//            let pathIdentifier = aScreen.pathIdentifier,
//            let flowIdentifier = aScreen.flowIdentifier
//        else {
//            return Route(flow: .current, paths: [], transition: transition)
//        }
//        let path: SomePath = .instance(pathIdentifier)
//        let flow: SomeFlow = .instance(flowIdentifier)
//        return Route(flow: flow, paths: [path], transition: transition)
//    }

    public static func next(
        _ paths: SomePath...,
        attachedTo anchorPath: AnchorPath = .current,
        transition: NavigationTransition = DefaultPushTransition()
    ) -> Self {
        return Route(flow: .current, paths: paths, attachedTo: anchorPath, transition: transition)
    }

    public static func stack(
        _ paths: SomePath...,
        attachedTo anchorPath: AnchorPath = .current,
        transition: DefaultStackTransition = DefaultStackTransition()
    ) -> Self {
        return Route(flow: .current, paths: paths, attachedTo: anchorPath, transition: transition)
    }

    public static func presented(
        _ paths: SomePath...,
        attachedTo anchorPath: AnchorPath = .current,
        transition: PresentationTransition = DefaultModalTransition()
    ) -> Self {
        return Route(flow: .current, paths: paths, attachedTo: anchorPath, transition: transition)
    }

    public static func builtInPresented(
        _ paths: SomePath...,
        attachedTo anchorPath: AnchorPath = .current,
        transition: BuiltInModalTransition = BuiltInModalTransition(presentationStyle: .fullScreen)
    ) -> Self {
        return Route(flow: .current, paths: paths, attachedTo: anchorPath, transition: transition)
    }

    public static func customPresented(
        _ paths: SomePath...,
        attachedTo anchorPath: AnchorPath = .current,
        transition: CustomModalTransition
    ) -> Self {
        return Route(flow: .current, paths: paths, attachedTo: anchorPath, transition: transition)
    }
}
