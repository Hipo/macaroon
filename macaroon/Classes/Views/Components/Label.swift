// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public class Label: UILabel, ShadowDrawable {
    public var shadow: Shadow?
    public var shadowLayer: CAShapeLayer?
    
    open var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        if let t = text, !t.isEmpty {
            let textRect = super.textRect(forBounds: bounds.inset(by: contentEdgeInsets), limitedToNumberOfLines: numberOfLines)
            return textRect.inset(by: contentEdgeInsets.inverted())
        }
        return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
    }

    open override func drawText(in rect: CGRect) {
        if let t = text, !t.isEmpty {
            super.drawText(in: rect.inset(by: contentEdgeInsets))
        } else {
            super.drawText(in: rect)
        }
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
