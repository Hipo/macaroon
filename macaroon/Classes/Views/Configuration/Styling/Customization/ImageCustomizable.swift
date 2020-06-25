// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ImageCustomizable: Customizable {
    func customizeAppearance(_ style: ImageStyling)
    func resetAppearance()
}

extension ImageCustomizable where Self: UIImageView {
    public func customizeAppearance(_ style: ImageStyling) {
        customizeBaseAppearance(style)

        contentMode = style.contentMode
        image = style.image
    }

    public func resetAppearance() {
        resetBaseAppearance()

        contentMode = .scaleToFill
        image = nil
    }
}

extension UIImageView: ImageCustomizable { }
