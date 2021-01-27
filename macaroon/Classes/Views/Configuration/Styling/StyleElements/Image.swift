// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Image {
    var origin: UIImage { get }
    var highlighted: UIImage? { get }
    var selected: UIImage? { get }
    var disabled: UIImage? { get }
}

extension Image {
    public var highlighted: UIImage? {
        return nil
    }
    public var selected: UIImage? {
        return nil
    }
    public var disabled: UIImage? {
        return nil
    }
}

extension UIImage: Image {
    public var origin: UIImage {
        return self
    }
}

public struct ImageSet: Image {
    public let origin: UIImage
    public let highlighted: UIImage?
    public let selected: UIImage?
    public let disabled: UIImage?

    public init(
        _ origin: UIImage,
        highlighted: UIImage? = nil,
        selected: UIImage? = nil,
        disabled: UIImage? = nil
    ) {
        self.origin = origin
        self.highlighted = highlighted
        self.selected = selected
        self.disabled = disabled
    }
}
