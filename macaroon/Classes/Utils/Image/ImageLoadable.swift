// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ImageLoadable {
    var imageContainer: UIImageView { get }

    func load(from source: ImageSource)
    func unloadSource()
}

extension ImageLoadable {
    public func load(from source: ImageSource) {
        source.load(in: imageContainer)
    }

    public func unloadSource() {
        imageContainer.image = nil
    }
}

extension UIImageView: ImageLoadable {
    public var imageContainer: UIImageView {
        return self
    }
}
