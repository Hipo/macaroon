// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ScreenRoutable {
    associatedtype Router: AppRouting

    var router: Router { get }
}

extension ScreenRoutable {
    public var router: NoAppRouting {
        return NoAppRouting()
    }
}

extension UIViewController: ScreenRoutable {
    public func openScreen<T: UIViewController>(_ destination: Router.Destination, by transition: AppRouterTransition.Open, animated: Bool = true, onCompleted handler: Router.TransitionHandler? = nil) -> T? {
        return router.openScreen(destination, from: self, by: transition, animated: animated, onCompleted: handler)
    }

    public func closeScreen(by transition: AppRouterTransition.Close, animated: Bool = true, onCompleted handler: Router.TransitionHandler? = nil) {
        router.closeScreen(self, by: transition, animated: animated, onCompleted: handler)
    }

    public func pop(animated: Bool = true, onCompleted handler: Router.TransitionHandler? = nil) {
        closeScreen(by: .navigation(.previous), animated: animated, onCompleted: handler)
    }

    public func popToRoot(animated: Bool = true, onCompleted handler: Router.TransitionHandler? = nil) {
        closeScreen(by: .navigation(.root), animated: animated, onCompleted: handler)
    }

    public func dismiss(onCompleted handler: Router.TransitionHandler? = nil) {
        closeScreen(by: .presentation, animated: true, onCompleted: handler)
    }
}
