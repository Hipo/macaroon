//
//  File.swift
//  
//
//  Created by ACS on 30.07.2022.
//

import UIKit
import SwiftUI

public protocol GradientDrawable: UIView {
    var gradient: Gradient? { get set }
    var gradientLayer: CAGradientLayer { get }
}

extension GradientDrawable {
    public func drawAppearance(
        gradient: Gradient?
    ) {
        guard let gradient = gradient else {
            eraseGradient()
            return
        }

        draw(
            gradient: gradient
        )

        self.gradient = gradient
    }
}

extension GradientDrawable {
    public func draw(
        gradient: Gradient
    ) {
        gradientLayer.draw(
            gradient: gradient
        )

        layer.addIfNeeded(gradientLayer: gradientLayer)

        updateOnLayoutSubviews(gradient: gradient)

        self.gradient = gradient
    }

    public func updateOnLayoutSubviews(
        gradient: Gradient
    ) {
        if bounds.isEmpty {
            return
        }

        gradientLayer.frame = bounds
    }

    public func eraseGradient() {
        gradientLayer.removeFromSuperlayer()
        gradientLayer.eraseGradient()

        gradient = nil
    }
}

extension CAGradientLayer {
    public func draw(
        gradient: Gradient
    ) {
        colors = gradient.colors
        frame = bounds
    }

    public func eraseGradient() {
        draw(
            gradient: Gradient(
                colors: []
            )
        )
    }
}

public struct Gradient {
    public let colors: [CGColor]

    public init(
        colors: [UIColor]
    ) {
        self.colors = colors.map(\.cgColor)
    }
}
