// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ControlComposable: ViewComposable {
    func recustomizeAppearance(for state: UIControl.State)
    func recustomizeAppearance(for touchState: ControlTouchState)
}

public enum ControlTouchState {
    case began
    case ended
}
