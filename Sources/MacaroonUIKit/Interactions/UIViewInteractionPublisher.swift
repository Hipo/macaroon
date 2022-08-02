// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol UIViewInteractionPublisher {
    associatedtype Event: Hashable
    
    var uiInteractions: [Event: UIInteraction] { get }
}

extension UIViewInteractionPublisher {
    public func startPublishing(
        event: Event,
        for control: UIControl
    ) {
        let interaction = uiInteractions[event] as? UIControlInteraction
        interaction?.link(control)
    }
    
    public func stopPublishing(
        event: Event
    ) {
        let interaction = uiInteractions[event] as? UIControlInteraction
        interaction?.unlink()
    }
}

extension UIViewInteractionPublisher {
    public func startPublishing(
        event: Event,
        for view: UIView
    ) {
        let interaction = uiInteractions[event] as? UIViewGestureInteraction
        interaction?.link(view)
    }

//    public func stopPublishing(
//        event: Event
//    ) {
//        let interaction = uiInteractions[event] as? UIViewGestureInteraction
//        interaction?.unlink()
//    }
}
