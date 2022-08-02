// Copyright © Hipolabs. All rights reserved.

import Foundation
import UIKit

public final class UIViewGestureInteraction: UIInteraction {
    private var view: UIView?
    private var handler: Handler?

    public init() { }
}

extension UIViewGestureInteraction {
    public func link(
        _ view: UIView
    ) {
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(deliverAction)
            )
        )

        self.view = view
    }

    public func unlink() {
        view?.removeGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(deliverAction)
            )
        )

        self.view = nil
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

extension UIViewGestureInteraction {
    @objc
    private func deliverAction() {
        handler?()
    }
}
