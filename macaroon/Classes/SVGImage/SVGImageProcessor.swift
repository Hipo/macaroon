// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Kingfisher
import Macaw

public struct SVGImageProcessor: ImageProcessor {
    public let identifier = "com.hipo.macaroon.imageProcessor.svg"

    private let size: CGSize

    public init(size: CGSize) {
        self.size = size
    }

    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            if let svgText = String(data: data, encoding: .utf8) {
                return try? SVGParser.parse(text: svgText).toNativeImage(size: size.macaw_scaled())
            }
            return nil
        }
    }
}
