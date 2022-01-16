// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol UIInteractionObservable {
    associatedtype Event: Hashable
    
    var uiInteractions: [Event: UIInteraction] { get }
}

extension UIInteractionObservable {
    public func observe(
        event: Event,
        handler: @escaping UIInteraction.Handler
    ) {
        let interaction = uiInteractions[event]
        interaction?.activate(handler)
    }
}
