// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Kingfisher

public struct SVGImageSource: URLImageSource {
    public let url: URL?
    public let color: UIColor?
    public let placeholder: ImagePlaceholder?
    public let size: CGSize

    public init(
        url: URL?,
        size: CGSize,
        color: UIColor? = nil,
        placeholder: ImagePlaceholder? = nil
    ) {
        self.url = url
        self.size = size
        self.color = color
        self.placeholder = placeholder
    }

    public func formImageProcessors() -> [ImageProcessor?] {
        return [SVGImageProcessor(size: size)]
    }
}
