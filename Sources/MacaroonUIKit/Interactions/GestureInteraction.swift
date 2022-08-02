// Copyright © Hipolabs. All rights reserved.

import Foundation
import UIKit

public final class GestureInteraction: UIInteraction {
    private var view: UIView?
    private var handler: Handler?

    private let gesture: Gesture

    public init(
        gesture: Gesture = .tap
    ) {
        self.gesture = gesture
    }
}

extension GestureInteraction {
    public func setHandler(
        _ handler: Handler?
    ) {
        self.handler = handler
    }
}

extension GestureInteraction {
    public func attach(
        to view: UIView
    ) {
        let recognizer = makeGestureRecognizer()
        view.addGestureRecognizer(recognizer)

        self.view = view
    }

    public func detachFromView() {
        guard let view = view else {
            return
        }

        let recognizer = makeGestureRecognizer()
        view.removeGestureRecognizer(recognizer)

        self.view = nil
    }

    private func makeGestureRecognizer() -> UIGestureRecognizer {
        switch gesture {
        case .tap: return makeTapGestureRecognizer()
        }
    }

    private func makeTapGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(deliverAction)
        )
    }
}

extension GestureInteraction {
    @objc
    private func deliverAction() {
        handler?()
    }
}

extension GestureInteraction {
    public enum Gesture {
        case tap
    }
}
