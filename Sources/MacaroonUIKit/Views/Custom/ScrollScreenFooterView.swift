// Copyright © 2019 hipolabs. All rights reserved.

import UIKit
import SnapKit

open class ScrollScreenFooterView: View {
    private lazy var blurBackgroundView = UIVisualEffectView()
    private lazy var gradientView = GradientView()

    public var effectStyle: EffectStyle = .none {
        willSet {
            switch newValue {
            case .blur(let blurEffectStyle):
                blurBackgroundView.effect = UIBlurEffect(style: blurEffectStyle)
            case .linearGradient(let gradient):
                gradientView.draw(gradient: gradient)
            default:
                return
            }
        }
    }

    open func customizeAppearance(_ styleSheet: NoStyleSheet) {}

    open func prepareLayout(_ layoutSheet: NoLayoutSheet) {}
}

extension ScrollScreenFooterView {
    public func addBlur() {
        if blurBackgroundView.isDescendant(
            of: self
        ) {
            return
        }

        insertSubview(
            blurBackgroundView,
            at: 0
        )

        blurBackgroundView.snp.makeConstraints {
            $0.setPaddings()
        }
    }

    public func addGradient() {
        if gradientView.isDescendant(
            of: self
        ) {
            return
        }

        insertSubview(
            gradientView,
            at: 0
        )

        gradientView.snp.makeConstraints {
            $0.setPaddings()
        }
    }

    public func setBlurVisible(_ isVisible: Bool) {
        blurBackgroundView.isHidden = !isVisible
    }

    public func setGradientVisible(_ isVisible: Bool) {
        gradientView.isHidden = !isVisible
    }
}

extension ScrollScreenFooterView {
    public enum EffectStyle {
        case none
        case blur(UIBlurEffect.Style)
        case linearGradient(Gradient)
    }
}
