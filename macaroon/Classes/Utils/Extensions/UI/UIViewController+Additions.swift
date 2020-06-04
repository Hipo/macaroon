// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UIViewController {
    public func dismissIfPresent(animated: Bool, completion: (() -> Void)? = nil) {
        if presentedViewController == nil {
            completion?()
        } else {
            dismiss(animated: animated, completion: completion)
        }
    }
}
