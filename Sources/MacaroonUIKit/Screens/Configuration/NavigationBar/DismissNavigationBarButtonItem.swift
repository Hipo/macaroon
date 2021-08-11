// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct DismissNavigationBarButtonItem: NavigationBarButtonItem {
    public let isOnlyVisibleAtRoot: Bool

    private let navigationBarButtonItem: CustomNavigationBarButtonItem

    public init(
        isOnlyVisibleAtRoot: Bool
    ) {
        self.isOnlyVisibleAtRoot = isOnlyVisibleAtRoot
        self.navigationBarButtonItem = CustomNavigationBarButtonItem()
    }
}

extension DismissNavigationBarButtonItem {
    public func apply(
        style: ButtonStyle
    ) {
        navigationBarButtonItem.apply(style: style)
    }

    public func apply(
        size: LayoutSize
    ) {
        navigationBarButtonItem.apply(size: size)
    }

    public func add(
        target: Any,
        action: Selector
    ) {
        navigationBarButtonItem.add(
            target: target,
            action: action
        )
    }
}

extension DismissNavigationBarButtonItem {
    public func asSystemBarButtonItem() -> UIBarButtonItem {
        return navigationBarButtonItem.asSystemBarButtonItem()
    }
}
