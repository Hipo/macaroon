// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ShadowDrawable: UIView {
    var shadow: Shadow? { get set }
    var shadowLayer: CAShapeLayer { get }
}

extension ShadowDrawable {
    public func drawAppearance(shadow: Shadow?) {
        drawAppearance(
            shadow: shadow,
            on: shadowLayer
        )

        self.shadow = shadow
    }
}

extension ShadowDrawable {
    public func draw(shadow: Shadow) {
        draw(
            shadow: shadow,
            on: shadowLayer
        )

        self.shadow = shadow
    }

    public func updateOnLayoutSubviews(shadow: Shadow) {
        updateOnLayoutSubviews(
            shadow: shadow,
            on: shadowLayer
        )
    }

    public func eraseShadow() {
        eraseShadow(from: shadowLayer)
        shadow = nil
    }
}

extension ShadowDrawable {
    func drawAppearance(
        shadow: Shadow?,
        on shadowLayer: CAShapeLayer
    ) {
        if let shadow = shadow {
            draw(
                shadow: shadow,
                on: shadowLayer
            )
        } else {
            eraseShadow(from: shadowLayer)
        }
    }

    func draw(
        shadow: Shadow,
        on shadowLayer: CAShapeLayer
    ) {
        shadowLayer.draw(shadow: shadow)

        layer.addIfNeeded(shadowLayer: shadowLayer)
        layer.masksToBounds = false

        updateOnLayoutSubviews(
            shadow: shadow,
            on: shadowLayer
        )
    }

    func updateOnLayoutSubviews(
        shadow: Shadow,
        on shadowLayer: CAShapeLayer
    ) {
        if bounds.isEmpty {
            return
        }

        shadowLayer.frame = bounds
        shadowLayer.drawPath(shadow: shadow)
    }

    func eraseShadow(from shadowLayer: CAShapeLayer) {
        shadowLayer.removeFromSuperlayer()
        shadowLayer.eraseShadow()
    }
}

extension CALayer {
    public func draw(shadow: Shadow) {
        shadowColor = shadow.color.cgColor
        shadowOpacity = shadow.opacity
        shadowOffset = shadow.offset
        shadowRadius = shadow.radius / 2

        if shadow.isRounded {
            maskedCorners = shadow.maskedCorners
            cornerRadius = shadow.cornerRadius
        }

        if shadow.shouldRasterize {
            shouldRasterize = shadow.shouldRasterize
            rasterizationScale = UIScreen.main.scale
        }

        if let shapeLayer = self as? CAShapeLayer {
            shapeLayer.backgroundColor = shadow.fillColor?.cgColor
            shapeLayer.fillColor = shadow.fillColor?.cgColor
            shapeLayer.zPosition = -1000
        } else {
            backgroundColor = shadow.fillColor?.cgColor
        }

        drawPath(shadow: shadow)
    }

    public func drawPath(shadow: Shadow) {
        if !bounds.isEmpty {
            shadowPath = calculatePath(shadow: shadow)
        }
    }

    private func calculatePath(shadow: Shadow) -> CGPath {
        let rect = calculatePathRect(shadow: shadow)

        if shadow.isRounded {
            return UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: shadow.corners,
                cornerRadii: shadow.cornerRadii
            ).cgPath
        } else {
            return UIBezierPath(rect: rect).cgPath
        }
    }

    private func calculatePathRect(shadow: Shadow) -> CGRect {
        let spread = shadow.spread

        if spread == 0 {
            return bounds
        } else {
            return bounds.insetBy(
                dx: -spread,
                dy: -spread
            )
        }
    }

    public func eraseShadow() {
        let defaultShadow = Shadow(
            color: .black,
            fillColor: nil,
            opacity: 0,
            offset: (0, -3),
            radius: 3
        )
        draw(shadow: defaultShadow)
    }
}

extension CALayer {
    public func addIfNeeded(shadowLayer: CAShapeLayer) {
        if let sublayers = sublayers, sublayers.contains(shadowLayer) {
            return
        }

        insertSublayer(
            shadowLayer,
            at: 0
        )
    }
}
