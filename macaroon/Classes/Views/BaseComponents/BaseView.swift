// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class BaseView: UIView, CornerRoundDrawable, ShadowDrawable {
    public var shadow: Shadow?
    public var shadowLayer: CAShapeLayer?

    open func preferredUserInterfaceStyleDidChange() {
        if let shadow = shadow {
            drawShadow(shadow)
        }
    }

    open func preferredContentSizeCategoryDidChange() { }

    open func prepareForReuse() { }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowWhenViewDidLayoutSubviews()
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                preferredUserInterfaceStyleDidChange()
            }
        }
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            preferredContentSizeCategoryDidChange()
        }
    }
}
