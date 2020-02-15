// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Kingfisher

extension Array where Element == ImageProcessor {
    public func joined() -> ImageProcessor? {
        var imageProcessor: ImageProcessor?

        forEach { anImageProcessor in
            imageProcessor = imageProcessor.map { $0 >> anImageProcessor } ?? anImageProcessor
        }
        return imageProcessor
    }
}

extension Array where Element == ImageProcessor? {
    public func compactJoined() -> ImageProcessor? {
        return compactMap { $0 }.joined()
    }
}
