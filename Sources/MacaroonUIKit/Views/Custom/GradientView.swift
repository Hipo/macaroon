// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

final class GradientView: View, GradientDrawable {
    public var gradient: Gradient?
    public private(set) lazy var gradientLayer: CAGradientLayer = CAGradientLayer()

    override func layoutSubviews() {
        if let gradient = gradient {
            updateOnLayoutSubviews(gradient: gradient)
        }

        super.layoutSubviews()
    }

    override func preferredUserInterfaceStyleDidChange() {
        super.preferredUserInterfaceStyleDidChange()

        drawAppearance(gradient: gradient)
    }

    func customizeAppearance(_ styleSheet: NoStyleSheet) {}

    func prepareLayout(_ layoutSheet: NoLayoutSheet) {}
}
