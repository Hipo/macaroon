// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol UIControlInteractionPublisher {
    associatedtype Event: Hashable
    
    var uiInteractions: [Event: UIInteraction] { get }
}

extension UIControlInteractionPublisher {
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
