// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ImageCustomizable: UIView {
    var mc_image: UIImage? { get set }
}

public protocol StateImageCustomizable: UIView {
    typealias State = UIControl.State

    func mc_setImage(_ image: UIImage?, for state: State)
}

extension UIButton: ImageCustomizable {
    public var mc_image: UIImage? {
        get { image(for: .normal) }
        set {
            setImage(
                newValue,
                for: .normal
            )
        }
    }
}

extension UIButton: StateImageCustomizable {
    public func mc_setImage(
        _ image: UIImage?,
        for state: State
    ) {
        setImage(
            image,
            for: state
        )
    }
}

extension UIImageView: ImageCustomizable {
    public var mc_image: UIImage? {
        get { image }
        set { image = newValue }
    }
}
