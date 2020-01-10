// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class Control<ViewLaunchArgs: ViewLaunchArgsConvertible>: UIControl, ViewLaunchable, ControlComposable, CornerRoundDrawable, ShadowDrawable {
    public var launchArgs: ViewLaunchArgs

    public lazy var shadowLayer = CAShapeLayer()

    open override var isEnabled: Bool {
        didSet {
            recustomizeAppearanceWhenStateChanged()
        }
    }
    open override var isSelected: Bool {
        didSet {
            recustomizeAppearanceWhenStateChanged()
        }
    }
    open override var isHighlighted: Bool {
        didSet {
            recustomizeAppearanceWhenStateChanged()
        }
    }

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

    open func recustomizeAppearance(for state: UIControl.State) { }
    open func recustomizeAppearance(for touchState: ControlTouchState) { }
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

    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        recustomizeAppearance(for: .began)
        return true
    }

    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        recustomizeAppearance(for: .began)
        return true
    }

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        recustomizeAppearance(for: .ended)
    }

    open override func cancelTracking(with event: UIEvent?) {
        recustomizeAppearance(for: .ended)
    }
}

extension Control {
    private func recustomizeAppearanceWhenStateChanged() {
        if isEnabled {
            if isSelected {
                recustomizeAppearance(for: .selected)
            } else if isHighlighted {
                recustomizeAppearance(for: .highlighted)
            } else {
                recustomizeAppearance(for: .normal)
            }
        } else {
            recustomizeAppearance(for: .disabled)
        }
    }
}
