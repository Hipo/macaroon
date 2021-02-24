// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Notification {
    public var isKeyboardLocal: Bool? {
        return (userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue
    }
    public var keyboardHeight: CGFloat? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
    }
    public var keyboardAnimationDuration: TimeInterval? {
        return userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
    }
    public var keyboardAnimationCurve: UIView.AnimationCurve? {
        let rawValue = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
        return rawValue.unwrap { UIView.AnimationCurve(rawValue: $0)?.validate() }
    }
}
