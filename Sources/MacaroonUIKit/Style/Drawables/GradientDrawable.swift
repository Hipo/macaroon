// Copyright © 2019 hipolabs. All rights reserved.

import UIKit
import SwiftUI

public protocol GradientDrawable: UIView {
    var gradient: Gradient? { get set }
    var gradientLayer: CAGradientLayer { get }
}

extension GradientDrawable {
    public func drawAppearance(gradient: Gradient?) {
        if let gradient = gradient {
            draw(gradient: gradient)
        } else {
            eraseGradient()
        }

        self.gradient = gradient
    }
}

extension GradientDrawable {
    public func draw(gradient: Gradient) {
        gradientLayer.draw(gradient: gradient)

        layer.addIfNeeded(gradientLayer: gradientLayer)

        updateOnLayoutSubviews(gradient: gradient)

        self.gradient = gradient
    }

    public func updateOnLayoutSubviews(gradient: Gradient) {
        if !bounds.isEmpty {
            gradientLayer.frame = bounds
        }
    }

    public func eraseGradient() {
        gradientLayer.removeFromSuperlayer()
        gradientLayer.eraseGradient()

        gradient = nil
    }
}

extension CAGradientLayer {
    public func draw(gradient: Gradient) {
        colors = gradient.colors?.map(\.uiColor.cgColor)
        locations = gradient.locations
        startPoint = gradient.startPoint
        endPoint = gradient.endPoint
        frame = bounds
    }

    public func eraseGradient() {
        let defaultGradient = Gradient()
        draw(gradient: defaultGradient)
    }
}

public struct Gradient {
    public var colors: [Color]?
    public var locations: [NSNumber]?
    public var startPoint: CGPoint
    public var endPoint: CGPoint

    public init() {
        self.startPoint = .init(x: 0.5, y: 0)
        self.endPoint = .init(x: 0.5, y: 1)
    }
}
