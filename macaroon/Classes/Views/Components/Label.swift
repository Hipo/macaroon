// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public class Label: UILabel {
    open var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    public private(set) lazy var shadowLayer = CAShapeLayer()

    private var shadow: Shadow?

    open override func textRect(
        forBounds bounds: CGRect,
        limitedToNumberOfLines numberOfLines: Int
    ) -> CGRect {
        let textRect =
            super.textRect(
                forBounds: bounds.inset(
                    by: contentEdgeInsets
                ),
                limitedToNumberOfLines: numberOfLines
            )

        if text.isNilOrEmpty { return textRect }

        return textRect.inset(
            by: contentEdgeInsets.inverted()
        )
    }

    open override func drawText(in rect: CGRect) {
        let someRect = text.isNilOrEmpty
            ? rect
            : rect.inset(
                by: contentEdgeInsets
            )
        super.drawText(
            in: someRect
        )
    }
    
    open func preferredUserInterfaceStyleDidChange() {
        guard let shadow = shadow else { return }

        customizeBaseAppearance(
            shadow: shadow
        )
    }
    
    open func preferredContentSizeCategoryDidChange() { }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        if let shadow = shadow {
            adjustOnLayoutSubviews(shadow)
        }
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(
            previousTraitCollection
        )

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
