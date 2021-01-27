//// Copyright © 2019 hipolabs. All rights reserved.
//
//import Foundation
//
//public protocol PresentationTransition: Transition { }
//
//extension PresentationTransition {
//    public func prepareForTransition(
//        to screens: [ScreenRoutable],
//        from fromScreen: ScreenRoutable
//    ) {
//        
//    }
//}
//
//public struct DefaultModalTransition: PresentationTransition {
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
//
//    }
//}
//
//public struct BuiltInModalTransition: PresentationTransition {
//    public var completion: (() -> Void)?
//
//    public let presentationStyle: UIModalPresentationStyle
//    public let transitionStyle: UIModalTransitionStyle?
//    public let animated: Bool
//
//    public init(
//        presentationStyle: UIModalPresentationStyle,
//        transitionStyle: UIModalTransitionStyle? = nil,
//        animated: Bool = true,
//        completion: (() -> Void)? = nil
//    ) {
//        self.presentationStyle = presentationStyle
//        self.transitionStyle = transitionStyle
//        self.animated = animated
//        self.completion = completion
//    }
//
//    public func perform(
//        to screens: [ScreenRoutable],
//        from fromScreen: ScreenRoutable
//    ) {
//
//    }
//}
//
//public struct CustomModalTransition: PresentationTransition {
//    public var completion: (() -> Void)?
//
//    public unowned let transitioningDelegate: UIViewControllerTransitioningDelegate
//    public let animated: Bool
//
//    public init(
//        transitioningDelegate: UIViewControllerTransitioningDelegate,
//        animated: Bool = true,
//        completion: (() -> Void)? = nil
//    ) {
//        self.transitioningDelegate = transitioningDelegate
//        self.animated = animated
//        self.completion = completion
//    }
//
//    public func perform(
//        to screens: [ScreenRoutable],
//        from fromScreen: ScreenRoutable
//    ) {
//
//    }
//}
