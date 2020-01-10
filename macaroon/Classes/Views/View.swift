// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class View<ViewLaunchArgs: ViewLaunchArgsConvertible>: UIView, ViewLaunchable, ViewComposable, CornerRoundDrawable, ShadowDrawable {
    public var launchArgs: ViewLaunchArgs

    public lazy var shadowLayer = CAShapeLayer()

    public init(_ launchArgs: ViewLaunchArgs) {
        self.launchArgs = launchArgs
        super.init(frame: .zero)
        compose()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func customizeAppearance() {
        customizeBaseAppearance(styleGuide)

        if let cornerRound = styleGuide.cornerRound {
            customizeCornerRoundAppearance(cornerRound)
        }
        if let shadow = styleGuide.shadow {
            customizeShadowAppearance(shadow)
        }
    }

    open func prepareLayout() { }
    open func setListeners() { }
    open func linkInteractors() { }
    open func prepareForReuse() { }

    open func preferredUserInterfaceStyleDidChange() {
        if let shadow = styleGuide.shadow {
            customizeShadowAppearance(shadow)
        }
    }

    open func preferredContentSizeCategoryDidChange() { }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if let shadow = styleGuide.shadow {
            updateShadowLayoutWhenViewDidLayoutSubviews(shadow)
        }
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

open class BindableView<ViewLaunchArgs: BindableViewLaunchArgsConvertible>: View<ViewLaunchArgs>, ViewModelBindable {
    open func bind(_ viewModel: ViewLaunchArgs.ViewModel) { }

    open class func preferredSize(fittingSize: CGSize, by viewModel: ViewLaunchArgs.ViewModel) -> CGSize {
        return fittingSize
    }
}
