// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

final class AlertShadowView:
    BaseView,
    DoubleShadowDrawable {
    var secondShadow: Shadow?

    private(set) lazy var secondShadowLayer: CAShapeLayer = .init()

    override func preferredUserInterfaceStyleDidChange() {
        super.preferredUserInterfaceStyleDidChange()
        drawAppearance(secondShadow: secondShadow)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let secondShadow = secondShadow {
            updateOnLayoutSubviews(secondShadow: secondShadow)
        }
    }
}
