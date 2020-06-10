// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol BorderDrawable: UIView {}

extension BorderDrawable {
    public func drawBorder(_ border: Border) {
        layer.borderColor = border.color.cgColor
        layer.borderWidth = border.width
    }
    
    public func removeBorder() {
        layer.borderWidth = 0.0
        layer.borderColor = nil
    }
}

public protocol CornerRoundDrawable: UIView { }

extension CornerRoundDrawable {
    public func drawCornerRound(_ cornerRound: CornerRound) {
        layer.cornerRadius = cornerRound.radius
        layer.maskedCorners = cornerRound.corners
        layer.masksToBounds = true
    }

    public func removeCornerRound() {
        layer.cornerRadius = 0.0
    }
}

extension UIView: CornerRoundDrawable { }

public protocol ShadowDrawable: UIView {
    var shadow: Shadow? { get set }
    var shadowLayer: CAShapeLayer? { get set }
}

extension ShadowDrawable {
    public func drawShadow(_ shadow: Shadow) {
        if let existingShadowLayer = shadowLayer {
            existingShadowLayer.draw(shadow)

            layer.masksToBounds = false
        } else {
            let newShadowLayer = CAShapeLayer()
            newShadowLayer.draw(shadow)

            layer.insertSublayer(newShadowLayer, at: 0)
            layer.masksToBounds = false

            shadowLayer = newShadowLayer
        }

        self.shadow = shadow
    }

    public func updateShadowWhenViewDidLayoutSubviews() {
        if bounds.isEmpty {
            return
        }
        guard
            let shadow = shadow,
            let shadowLayer = shadowLayer
        else {
            removeShadow()
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
        shadowLayer?.removeFromSuperlayer()
        shadowLayer = nil

        shadow = nil
    }
}

extension CALayer {
    public func set(shadow: Shadow) {
        shadowColor = shadow.color.cgColor
        shadowOpacity = shadow.opacity
        shadowOffset = shadow.offset
        shadowRadius = shadow.radius
    }
}

extension CAShapeLayer {
    public func draw(_ shadow: Shadow) {
        set(shadow: shadow)
        fillColor = shadow.fillColor.cgColor
    }
}
