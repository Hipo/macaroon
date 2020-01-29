// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class Control: UIControl, CornerRoundDrawable, ShadowDrawable {
    public var shadow: Shadow?
    public var shadowLayer: CAShapeLayer?

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

    public init() {
        super.init(frame: .zero)
        customizeAppearance()
        prepareLayout()
        setListeners()
        linkInteractors()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func customizeAppearance() { }
    open func recustomizeAppearance(for state: UIControl.State) { }
    open func recustomizeAppearance(for touchState: Control.TouchState) { }
    open func prepareLayout() { }
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
    public func recustomizeAppearanceWhenStateChanged() {
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

extension Control {
    public enum TouchState {
        case began
        case ended
    }
}
