// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class Control<ViewLaunchArgs: ViewLaunchArgsConvertible>: BaseControl {
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
    open func recustomizeAppearance(for state: UIControl.State) { }
    open func recustomizeAppearance(for touchState: Control.TouchState) { }
    open func prepareLayout(_ launchArgs: ViewLaunchArgs) { }
    open func setListeners() { }
    open func linkInteractors() { }

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
