// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ImageProvider {
    func load(
        in view: ImageCustomizable
    )
}

public protocol StateImageProvider {
    func load(
        in view: StateImageCustomizable
    )
}

extension UIImage:
    ImageProvider,
    StateImageProvider {
    public func load(
        in view: ImageCustomizable
    ) {
        view.mc_image = self
    }

    public func load(
        in view: StateImageCustomizable
    ) {
        view.mc_setImage(
            self,
            for: .normal
        )
    }
}
