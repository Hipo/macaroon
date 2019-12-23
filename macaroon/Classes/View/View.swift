// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class View<SomeViewLaunchArgs: ViewLaunchArgsConvertible>: UIView, ViewLaunchable, ViewComposable {
    public var launchArgs: SomeViewLaunchArgs

    public init(launchArgs: SomeViewLaunchArgs) {
        self.launchArgs = launchArgs
        super.init(frame: .zero)
        compose()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func customizeAppearance() { }
    open func prepareLayout() { }
    open func setListeners() { }
    open func linkInteractors() { }
    open func prepareForReuse() { }

    open func preferredUserInterfaceStyleDidChange() { }
    open func preferredContentSizeCategoryDidChange() { }

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

public class BindableView<SomeViewLaunchArgs: BindableViewLaunchArgsConvertible>: View<SomeViewLaunchArgs>, ViewModelBindable {
    open func bind(_ viewModel: SomeViewLaunchArgs.SomeViewModel) { }

    open class func preferredSize(fittingSize: CGSize, by viewModel: SomeViewLaunchArgs.SomeViewModel) -> CGSize {
        return fittingSize
    }
}
