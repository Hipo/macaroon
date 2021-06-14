// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UIStackView {
    public func deleteArrangedSubview(
        _ view: UIView
    ) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    public func deleteAllArrangedSubviews() {
        arrangedSubviews.forEach(deleteArrangedSubview)
    }

    public func deleteAllSubviews() {
        deleteAllArrangedSubviews()

        subviews
            .reversed()
            .forEach { $0.removeFromSuperview() }
    }
}
