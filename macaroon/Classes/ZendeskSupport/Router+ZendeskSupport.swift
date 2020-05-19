// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Router {
    @discardableResult
    public func openZendesk(_ zendesk: ZendeskHandler, for identity: ZendeskIdentity?, from source: UIViewController, by transition: RoutingTransition.Open, animated: Bool, onCompleted handler: TransitionHandler?) -> UIViewController {
        let screen = zendesk.makeScreen(identity)

        switch transition {
        case .navigation(let navigation):
            pushScreen(screen, from: source, by: navigation, animated: animated, onCompleted: handler)
        case .presentation(let presentation):
            presentScreen(screen, from: source, by: presentation, animated: animated, onCompleted: handler)
        }
        return screen
    }
}
