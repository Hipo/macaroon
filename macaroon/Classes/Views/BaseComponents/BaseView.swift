// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class BaseView: UIView, ShadowDrawable {
    public var shadow: Shadow?
    public var shadowLayer: CAShapeLayer?

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func preferredUserInterfaceStyleDidChange() {
        if let shadow = shadow {
            drawShadow(shadow)
        }
    }

    open func preferredContentSizeCategoryDidChange() { }

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

public typealias View = BaseView & ViewComposable
