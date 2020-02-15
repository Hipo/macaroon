// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Kingfisher

public protocol URLImageSource: ImageSource {
    var url: URL? { get }
    var placeholder: ImagePlaceholder? { get }

    func load(in imageView: UIImageView, displayingPlaceholderIn placeholderContainer: URLImagePlaceholderContainer?)
    func formOptions() -> KingfisherOptionsInfo
    func formImageProcessors() -> [ImageProcessor?]
}

extension URLImageSource {
    public func load(in imageView: UIImageView) {
        load(in: imageView, displayingPlaceholderIn: nil)
    }

    public func load(in imageView: UIImageView, displayingPlaceholderIn placeholderContainer: URLImagePlaceholderContainer?) {
        imageView.kf.cancelDownloadTask()
        imageView.kf.setImage(with: url, placeholder: placeholderContainer, options: formOptions())

        placeholderContainer?.placeholder = placeholder
    }

    public func formOptions() -> KingfisherOptionsInfo {
        var options = formDefaultOptions()

        if let imageProcessor = formImageProcessors().compactJoined() {
            options.append(.processor(imageProcessor))
        }
        return options
    }
}

extension URLImageSource {
    public func formDefaultOptions() -> KingfisherOptionsInfo {
        return [
            .transition(.fade(0.2))
        ]
    }
}
