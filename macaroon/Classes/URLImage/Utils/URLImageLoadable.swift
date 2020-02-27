// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Kingfisher
import UIKit

public protocol URLImageLoadable: ImageLoadable {
    var placeholderContainer: URLImagePlaceholderContainer? { get }
}

extension URLImageLoadable {
    public func load(from source: ImageSource?) {
        guard let source = source else {
            unloadSource()
            return
        }
        if let urlSource = source as? PNGImageSource {
            urlSource.load(in: imageContainer, displayingPlaceholderIn: placeholderContainer)
        } else {
            source.load(in: imageContainer)
        }
    }

    public func unloadSource() {
        imageContainer.kf.cancelDownloadTask()
        imageContainer.image = nil
    }
}
