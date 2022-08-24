// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol UIInteractable {
    associatedtype Event: Hashable
    
    var uiInteractions: [Event: UIInteraction] { get }
}

extension UIInteractable {
    public func startObserving(
        event: Event,
        using block: @escaping () -> Void
    ) {
        let interaction = uiInteractions[event]
        interaction?.setSelector(block)
    }

    public func stopObserving(event: Event) {
        let interaction = uiInteractions[event]
        interaction?.setSelector(nil)
    }
}

extension UIInteractable {
    public func startPublishing(
        event: Event,
        for view: UIView
    ) {
        let interaction = uiInteractions[event]
        interaction?.attach(to: view)
    }

    public func stopPublishing(
        event: Event,
        for view: UIView
    ) {
        let interaction = uiInteractions[event]
        interaction?.attach(to: view)
    }
}
