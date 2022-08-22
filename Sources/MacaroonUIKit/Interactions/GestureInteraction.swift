// Copyright © Hipolabs. All rights reserved.

import Foundation
import UIKit

public final class GestureInteraction: UIInteraction {
    private var view: UIView?
    private var selector: (() -> Void)?

    private let gesture: Gesture

    public init(gesture: Gesture = .tap) {
        self.gesture = gesture
    }
}

extension GestureInteraction {
    public func setSelector(_ selector: (() -> Void)?) {
        self.selector = selector
    }
}

extension GestureInteraction {
    public func attach(to view: UIView) {
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
        case .longPress: return makeLongPressGestureRecognizer()
        }
    }

    private func makeTapGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(publish)
        )
    }

    private func makeLongPressGestureRecognizer() -> UILongPressGestureRecognizer {
        return UILongPressGestureRecognizer(
            target: self,
            action: #selector(publishForLongPressGesture(_:))
        )
    }
}

extension GestureInteraction {
    @objc
    public func publish() {
        selector?()
    }

    @objc
    private func publishForLongPressGesture(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            publish()
        }
    }
}

extension GestureInteraction {
    public enum Gesture {
        case tap
        case longPress
    }
}
