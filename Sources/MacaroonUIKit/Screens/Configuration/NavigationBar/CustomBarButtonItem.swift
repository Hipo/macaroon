// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public protocol CustomBarButtonItem: NavigationBarButtonItem {
    var customControl: UIControl { get }
    var customSize: LayoutSize { get }
}

extension CustomBarButtonItem {
    public var customSize: LayoutSize {
        return (.noMetric, .noMetric)
    }

    public func add(
        target: Any,
        action: Selector
    ) {
        customControl.addTarget(
            target,
            action: action,
            for: .touchUpInside
        )
    }

    public func asSystemBarButtonItem() -> UIBarButtonItem {
        customControl.snp.makeConstraints {
            $0.fitToSize(customSize)
        }

        return UIBarButtonItem(customView: customControl)
    }
}
