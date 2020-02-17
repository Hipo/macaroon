// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ImageSource {
    func load(in imageView: UIImageView)
}

public struct NoImageSource: ImageSource {
    public init() { }

    public func load(in imageView: UIImageView) {
        imageView.image = nil
    }
}

public struct AssetImageSource: ImageSource {
    public let asset: UIImage?
    public let color: UIColor?

    public init(
        asset: UIImage?,
        color: UIColor? = nil
    ) {
        self.asset = asset
        self.color = color
    }

    public func load(in imageView: UIImageView) {
        if let color = color {
            imageView.image = asset?.template
            imageView.tintColor = color
        } else {
            imageView.image = asset
        }
    }
}
