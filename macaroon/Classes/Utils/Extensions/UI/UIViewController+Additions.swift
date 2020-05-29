// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UIViewController {
    public func continueAfterDismiss(animated: Bool = true, _ closure: @escaping () -> Void) {
        if presentedViewController == nil {
            closure()
        } else {
            dismiss(animated: animated) {
                closure()
            }
        }
    }
}
