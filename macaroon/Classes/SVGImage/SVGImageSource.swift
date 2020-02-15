// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Kingfisher

public struct SVGImageSource: URLImageSource {
    public let url: URL?
    public let placeholder: ImagePlaceholder?
    public let size: CGSize

    public init(
        url: URL?,
        size: CGSize,
        placeholder: ImagePlaceholder? = nil
    ) {
        self.url = url
        self.placeholder = placeholder
        self.size = size
    }

    public func formImageProcessors() -> [ImageProcessor?] {
        return [SVGImageProcessor(size: size)]
    }
}
