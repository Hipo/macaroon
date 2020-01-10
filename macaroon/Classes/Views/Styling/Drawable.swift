// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol CornerRoundDrawable: UIView { }

extension CornerRoundDrawable {
    public func customizeCornerRoundAppearance(_ cornerRound: CornerRound) {
        layer.cornerRadius = cornerRound.radius
        layer.maskedCorners = cornerRound.corners
        layer.masksToBounds = true
    }

    public func removeCornerRound() {
        layer.cornerRadius = 0.0
    }
}

public protocol ShadowDrawable: UIView {
    var shadowLayer: CAShapeLayer { get }
}

extension ShadowDrawable {
    public func customizeShadowAppearance(_ shadow: Shadow) {
        shadowLayer.shadowColor = shadow.color.cgColor
        shadowLayer.fillColor = shadow.fillColor.cgColor
        shadowLayer.shadowOpacity = shadow.opacity
        shadowLayer.shadowOffset = shadow.offset
        shadowLayer.shadowRadius = shadow.radius

        let currentSublayers = layer.sublayers ?? []

        if !currentSublayers.contains(shadowLayer) {
            layer.insertSublayer(shadowLayer, at: 0)
            layer.masksToBounds = false
        }
    }

    public func updateShadowLayoutWhenViewDidLayoutSubviews(_ shadow: Shadow) {
        if bounds.isEmpty {
            return
        }
        shadowLayer.frame = bounds

        if shadow.hasRoundCorners() {
            shadowLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: shadow.corners, cornerRadii: shadow.cornerRadii).cgPath
        } else {
            shadowLayer.path = UIBezierPath(rect: bounds).cgPath
        }
    }

    public func removeShadow() {
        shadowLayer.removeFromSuperlayer()
    }
}
