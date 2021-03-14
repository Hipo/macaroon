// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol DoubleShadowDrawable: ShadowDrawable {
    var secondShadow: Shadow? { get set }
    var secondShadowLayer: CAShapeLayer { get }
}

extension DoubleShadowDrawable {
    public func drawAppearance(
        secondShadow: Shadow?
    ) {
        drawAppearance(
            shadow: secondShadow,
            on: secondShadowLayer
        )

        self.secondShadow = secondShadow
    }
}

extension DoubleShadowDrawable {
    public func draw(
        secondShadow: Shadow
    ) {
        draw(
            shadow: secondShadow,
            on: secondShadowLayer
        )

        self.secondShadow = secondShadow
    }

    public func updateOnLayoutSubviews(
        secondShadow: Shadow
    ) {
        updateOnLayoutSubviews(
            shadow: secondShadow,
            on: secondShadowLayer
        )
    }

    public func eraseSecondShadow() {
        eraseShadow(
            from: secondShadowLayer
        )

        self.secondShadow = nil
    }
}
