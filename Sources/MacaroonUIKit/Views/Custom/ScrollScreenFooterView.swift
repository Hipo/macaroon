//
//  File.swift
//  
//
//  Created by ACS on 1.08.2022.
//

import UIKit
import SnapKit

open class ScrollScreenFooterView:
    View,
    GradientDrawable {
    public var gradient: Gradient?
    public private(set) lazy var gradientLayer: CAGradientLayer = CAGradientLayer()

    public private(set) lazy var blurBackgroundView = UIVisualEffectView()

    public var effectStyle: EffectStyle = .none {
        willSet {
            switch newValue {
            case .blur(let blurEffectStyle):
                blurBackgroundView.effect = UIBlurEffect(style: blurEffectStyle)
            case .linearGradient(let gradient):
                draw(gradient: gradient)
            default:
                return
            }
        }
    }

    open override func layoutSubviews() {
        if let gradient = gradient {
            updateOnLayoutSubviews(gradient: gradient)
        }

        super.layoutSubviews()
    }

    open override func preferredUserInterfaceStyleDidChange() {
        super.preferredUserInterfaceStyleDidChange()

        drawAppearance(gradient: gradient)
    }

    open func customizeAppearance(_ styleSheet: NoStyleSheet) {}

    open func prepareLayout(_ layoutSheet: NoLayoutSheet) {}
}

extension ScrollScreenFooterView {
    open func addBlur() {
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
}

extension ScrollScreenFooterView {
    public enum EffectStyle {
        case none
        case blur(UIBlurEffect.Style)
        case linearGradient(Gradient)
    }
}
