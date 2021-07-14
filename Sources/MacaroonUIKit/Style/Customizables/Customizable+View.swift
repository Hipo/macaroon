// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Customizable where Self: UIView {
    public func customizeAppearance(
        _ style: ViewStyle
    ) {
        customizeBaseAppearance(backgroundColor: style.backgroundColor)
        customizeBaseAppearance(tintColor: style.tintColor)
        customizeBaseAppearance(isInteractable: style.isInteractable)
    }

    public func recustomizeAppearance(
        _ style: ViewStyle
    ) {
        resetAppearance()
        customizeAppearance(style)
    }
}
