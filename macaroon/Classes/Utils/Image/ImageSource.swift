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

    public init(asset: UIImage?) {
        self.asset = asset
    }

    public func load(in imageView: UIImageView) {
        imageView.image = asset
    }
}
