// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ImageLoadable {
    var imageContainer: UIImageView { get }

    func load(from source: ImageSource?)
    func unloadSource()
}

extension ImageLoadable {
    public func load(from source: ImageSource?) {
        if let source = source {
            source.load(in: imageContainer)
        } else {
            unloadSource()
        }
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
