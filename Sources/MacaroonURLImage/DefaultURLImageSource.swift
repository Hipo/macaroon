// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Kingfisher
import UIKit

public struct DefaultURLImageSource: URLImageSource {
    public let url: URL?
    public let color: UIColor?
    public let placeholder: ImagePlaceholder?
    public let size: ImageSize
    public let shape: ImageShape
    public let scale: CGFloat
    public let forceRefresh: Bool

    public init(
        url: URL?,
        color: UIColor? = nil,
        size: ImageSize = .original,
        shape: ImageShape = .original,
        placeholder: ImagePlaceholder? = nil,
        scale: CGFloat = UIScreen.main.scale,
        forceRefresh: Bool = false
    ) {
        self.url = url
        self.color = color
        self.placeholder = placeholder
        self.size = size
        self.shape = shape
        self.scale = scale
        self.forceRefresh = forceRefresh
    }
}

extension DefaultURLImageSource {
    public func formOptions() -> KingfisherOptionsInfo {
        var options: KingfisherOptionsInfo = []
        appendDefaultOptions(to: &options)
        appendOptionForForceRefreshIfNeeded(to: &options)
        appendOptionForImageProcessorIfNeeded(to: &options)
        appendOptionForCacheSerializer(to: &options)
        return options
    }

    private func appendOptionForCacheSerializer(to options: inout KingfisherOptionsInfo) {
        var cacheSerializer = DefaultCacheSerializer.default
        cacheSerializer.preferCacheOriginalData = true

        options.append(.cacheSerializer(cacheSerializer))
    }

    public func formImageProcessors() -> [ImageProcessor?] {
        return [
            formSizeImageProcessor(),
            formShapeImageProcessor()
        ]
    }

    private func formSizeImageProcessor() -> ImageProcessor? {
        switch shape {
        case .circle,
             .rounded:
            return nil
        default:
            switch size {
            case .original:
                return nil
            case .resize(let referenceSize, let mode):
                return ResizingImageProcessor(referenceSize: referenceSize.scaled(scale), mode: mode)
            case .cropping(let targetSize):
                return CroppingImageProcessor(size: targetSize)
            case .downsampling(let targetSize):
                return DownsamplingImageProcessor(size: targetSize)
            }
        }
    }

    private func formShapeImageProcessor() -> ImageProcessor? {
        switch shape {
        case .original:
            return nil
        case .circle:
            return RoundCornerImageProcessor(
                radius: .widthFraction(0.5),
                targetSize: size.reduce()?.scaled(scale),
                backgroundColor: .clear
            )
        case .rounded(let cornerRadius):
            return RoundCornerImageProcessor(
                radius: .point(cornerRadius.scaled(scale)),
                targetSize: size.reduce()?.scaled(scale),
                backgroundColor: .clear
            )
        }
    }
}
