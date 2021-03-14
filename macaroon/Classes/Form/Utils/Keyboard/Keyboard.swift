// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct Keyboard {
    public let isLocal: Bool
    public let height: LayoutMetric
    public let animationDuration: TimeInterval
    public let animationCurve: UIView.AnimationCurve

    public init(
        notification: Notification
    ) {
        self.isLocal = notification.isKeyboardLocal ?? true
        self.height = notification.keyboardHeight ?? 0
        self.animationDuration = notification.keyboardAnimationDuration ?? 0.25
        self.animationCurve = notification.keyboardAnimationCurve ?? .easeOut
    }
}
