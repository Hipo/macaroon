// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol NavigationBarButtonItem {
    func asSystemBarButtonItem() -> UIBarButtonItem
}

extension UIBarButtonItem: NavigationBarButtonItem {
    public func asSystemBarButtonItem() -> UIBarButtonItem {
        return self
    }
}
