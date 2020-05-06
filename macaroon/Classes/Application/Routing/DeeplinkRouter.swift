// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol DeeplinkRouter: Router {
    associatedtype SomeDeeplinkParser: DeeplinkParser where SomeDeeplinkParser.Destination == Destination

    var deeplinkParser: SomeDeeplinkParser { get }

    func openScreen<T: UIViewController>(_ url: URL, from source: UIViewController, by transition: RoutingTransition.Open, animated: Bool, onCompleted handler: TransitionHandler?) -> T?
}

extension DeeplinkRouter {
    @discardableResult
    public func openScreen<T: UIViewController>(_ url: URL, from source: UIViewController, by transition: RoutingTransition.Open = .presentation(), animated: Bool = true, onCompleted handler: TransitionHandler? = nil) -> T? {
        return deeplinkParser.discover(url: url).unwrapIfPresent(either: { openScreen($0, from: source, by: transition, animated: animated, onCompleted: handler) })
    }
}
