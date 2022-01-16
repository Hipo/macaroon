// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public final class UIControlInteraction: UIInteraction {
    private var control: UIControl?
    private var handler: Handler?

    private let event: UIControl.Event

    public init(
        event: UIControl.Event = .touchUpInside
    ) {
        self.event = event
    }
}

extension UIControlInteraction {
    public func link(
        _ control: UIControl
    ) {
        control.addTarget(
            self,
            action: #selector(deliverAction),
            for: event
        )

        self.control = control
    }

    public func unlink() {
        control?.removeTarget(
            self,
            action: #selector(deliverAction),
            for: event
        )

        self.control = nil
    }

    public func activate(
        _ handler: @escaping Handler
    ) {
        self.handler = handler
    }

    public func deactivate() {
        self.handler = nil
    }
}

extension UIControlInteraction {
    @objc
    private func deliverAction() {
        handler?()
    }
}
