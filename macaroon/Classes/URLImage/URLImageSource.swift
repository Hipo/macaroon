// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Kingfisher

public protocol URLImageSource: ImageSource {
    var url: URL? { get }
    var color: UIColor? { get }
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
        imageView.kf.setImage(with: url, placeholder: placeholderContainer, options: formOptions(), progressBlock: nil) { result in
            switch result {
            case .success(let imageResult):
                if let color = self.color {
                    imageView.image = imageResult.image.template
                    imageView.tintColor = color
                } else {
                    imageView.image = imageResult.image
                }
            case .failure:
                imageView.image = nil
            }
        }

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