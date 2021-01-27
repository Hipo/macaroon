// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ShadowDrawable: UIView {
    var shadowLayer: CAShapeLayer? { get }

    func draw(_ shadow: Shadow)
    func adjustOnLayoutSubviews(_ shadow: Shadow)
    func eraseShadow()
}

extension ShadowDrawable {
    public var shadowLayer: CAShapeLayer? {
        return nil
    }
}

extension ShadowDrawable {
    public func draw(
        _ shadow: Shadow
    ) {
        defer {
            layer.masksToBounds = false

            adjustOnLayoutSubviews(
                shadow
            )
        }

        guard let shadowLayer = shadowLayer else {
            layer.draw(
                shadow
            )
            return
        }

        shadowLayer.draw(
            shadow
        )

        if let sublayers = layer.sublayers,
           sublayers.contains(
               shadowLayer
           ) { return }

        layer.insertSublayer(
            shadowLayer,
            at: 0
        )
    }

    public func adjustOnLayoutSubviews(
        _ shadow: Shadow
    ) {
        if bounds.isEmpty { return }

        guard let shadowLayer = shadowLayer else {
            layer.frame = bounds
            layer.drawPath(
                shadow
            )

            return
        }

        shadowLayer.frame = bounds
        shadowLayer.drawPath(
            shadow
        )
    }

    public func eraseShadow() {
        guard let shadowLayer = shadowLayer else {
            layer.draw(
                Shadow(
                    color: .black,
                    opacity: 0.0,
                    offset: (0, -3),
                    radius: 3.0,
                    fillColor: nil
                )
            )
            return
        }

        shadowLayer.removeFromSuperlayer()
    }
}

extension CALayer {
    public func draw(
        _ shadow: Shadow
    ) {
        shadowColor = shadow.color.cgColor
        shadowOpacity = shadow.opacity
        shadowOffset = shadow.offset
        shadowRadius = shadow.radius

        if let shapeLayer = self as? CAShapeLayer {
            shapeLayer.fillColor = shadow.fillColor?.cgColor
            shapeLayer.zPosition = -1000
        } else {
            backgroundColor = shadow.fillColor?.cgColor
        }

        drawPath(
            shadow
        )
    }

    public func drawPath(
        _ shadow: Shadow
    ) {
        func calculatePath() -> CGPath {
            if shadow.isRounded {
                return UIBezierPath(
                    roundedRect: bounds,
                    byRoundingCorners: shadow.corners,
                    cornerRadii: shadow.cornerRadii
                ).cgPath
            }

            return UIBezierPath(rect: bounds).cgPath
        }

        if bounds.isEmpty { return }

        if let shapeLayer = self as? CAShapeLayer {
            shapeLayer.path = calculatePath()
        } else {
            shadowPath = calculatePath()
        }
    }
}

extension UIView: ShadowDrawable {}
