// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ShadowDrawable: UIView {
    var shadow: Shadow? { get set }
    var shadowLayer: CAShapeLayer { get }
}

extension ShadowDrawable {
    public func drawAppearance(
        shadow: Shadow?
    ) {
        guard let shadow = shadow else {
            eraseShadow()
            return
        }

        draw(
            shadow
        )
    }
}

extension ShadowDrawable {
    public func draw(
        _ someShadow: Shadow
    ) {
        defer {
            layer.masksToBounds = false

            updateOnLayoutSubviews(
                someShadow
            )

            shadow = someShadow
        }

        shadowLayer.draw(
            someShadow
        )

        if let sublayers = layer.sublayers,
           sublayers.contains(
               shadowLayer
           ) {
            return
        }

        layer.insertSublayer(
            shadowLayer,
            at: 0
        )
    }

    public func updateOnLayoutSubviews(
        _ someShadow: Shadow
    ) {
        if bounds.isEmpty {
            return
        }

        shadowLayer.frame = bounds
        shadowLayer.drawPath(
            someShadow
        )
    }

    public func eraseShadow() {
        shadowLayer.removeFromSuperlayer()
        shadowLayer.eraseShadow()

        shadow = nil
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

        if bounds.isEmpty {
            return
        }

        if let shapeLayer = self as? CAShapeLayer {
            shapeLayer.path = calculatePath()
        } else {
            shadowPath = calculatePath()
        }
    }

    public func eraseShadow() {
        draw(
            Shadow(
                color: .black,
                opacity: 0,
                offset: (0, -3),
                radius: 3,
                fillColor: nil
            )
        )
    }
}
