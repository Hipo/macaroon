// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public final class TargetActionInteraction: UIInteraction {
    private var view: UIControl?
    private var selector: (() -> Void)?

    private let event: UIControl.Event

    public init(event: UIControl.Event = .touchUpInside) {
        self.event = event
    }
}

extension TargetActionInteraction {
    public func setSelector(_ selector: (() -> Void)?) {
        self.selector = selector
    }
}

extension TargetActionInteraction {
    public func attach(to view: UIView) {
        assert(
            view is UIControl,
            "Only the views inherited from `UIControl` can be interacted."
        )

        let targetView = view as? UIControl
        targetView?.addTarget(
            self,
            action: #selector(publish),
            for: event
        )

        self.view = targetView
    }

    public func detachFromView() {
        view?.removeTarget(
            self,
            action: #selector(publish),
            for: event
        )

        self.view = nil
    }
}

extension TargetActionInteraction {
    @objc
    public func publish() {
        selector?()
    }
}
