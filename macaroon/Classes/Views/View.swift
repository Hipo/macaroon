// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class View<ViewLaunchArgs: ViewLaunchArgsConvertible>: UIView, CornerRoundDrawable, ShadowDrawable {
    public var shadow: Shadow?
    public var shadowLayer: CAShapeLayer?

    public init(_ launchArgs: ViewLaunchArgs) {
        super.init(frame: .zero)
        customizeAppearance(launchArgs)
        prepareLayout(launchArgs)
        setListeners()
        linkInteractors()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func customizeAppearance(_ launchArgs: ViewLaunchArgs) { }
    open func prepareLayout(_ launchArgs: ViewLaunchArgs) { }
    open func setListeners() { }
    open func linkInteractors() { }
    open func prepareForReuse() { }

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

public protocol ViewLaunchArgsConvertible { }

public struct NoViewLaunchArgs: ViewLaunchArgsConvertible { }
