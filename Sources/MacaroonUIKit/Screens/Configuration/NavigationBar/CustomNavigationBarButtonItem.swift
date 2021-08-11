// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct CustomNavigationBarButtonItem: NavigationBarButtonItem {
    private let actionView: Button

    public init(
        layout: Button.Layout = .none
    ) {
        self.actionView = Button(layout)
    }
}

extension CustomNavigationBarButtonItem {
    public func apply(
        style: ButtonStyle
    ) {
        actionView.customizeAppearance(style)
    }

    public func apply(
        size: LayoutSize
    ) {
        actionView.snp.makeConstraints {
            $0.fitToSize(size)
        }
    }

    public func add(
        target: Any,
        action: Selector
    ) {
        actionView.addTouch(
            target: target,
            action: action
        )
    }
}

extension CustomNavigationBarButtonItem {
    public func asSystemBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(customView: actionView)
    }
}
