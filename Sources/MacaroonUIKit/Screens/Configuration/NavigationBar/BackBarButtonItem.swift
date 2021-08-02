// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct BackBarButtonItem: NavigationBarButtonItem {
    public let popBarButtonItem: NavigationBarButtonItem
    public let dismissBarButtonItem: NavigationBarButtonItem

    public init(
        pop popBarButtonItem: NavigationBarButtonItem,
        dismiss dismissBarButtonItem: NavigationBarButtonItem
    ) {
        self.popBarButtonItem = popBarButtonItem
        self.dismissBarButtonItem = dismissBarButtonItem
    }

    public func asSystemBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem()
    }
}

extension BackBarButtonItem {
    public enum Operation {
        case pop
        case dismiss
    }
}
