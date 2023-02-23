// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Kingfisher
import MacaroonUIKit
import UIKit

public protocol URLImageSource: ImageSource {
    var url: URL? { get }
    var color: UIColor? { get }
    var placeholder: ImagePlaceholder? { get }
    var forceRefresh: Bool { get }

    func load(in imageView: UIImageView, displayingPlaceholderIn placeholderContainer: URLImagePlaceholderContainer?, onCompleted execute: ((Swift.Error?) -> Void)?)
    func formOptions() -> KingfisherOptionsInfo
    func formImageProcessors() -> [ImageProcessor?]
}

extension URLImageSource {
    public func load(
        in imageView: UIImageView,
        onCompleted execute: ((Swift.Error?) -> Void)? = nil
    ) {
        load(
            in: imageView,
            displayingPlaceholderIn: nil,
            onCompleted: execute
        )
    }

    public func load(
        in imageView: UIImageView,
        displayingPlaceholderIn placeholderContainer: URLImagePlaceholderContainer?,
        onCompleted execute: ((Swift.Error?) -> Void)? = nil
    ) {
        imageView.kf.setImage(
            with: url,
            placeholder: placeholderContainer,
            options: formOptions(),
            progressBlock: nil
        ) { result in
            switch result {
            case .success(let imageResult):
                if let color = self.color {
                    imageView.image = imageResult.image.template
                    imageView.tintColor = color
                } else {
                    imageView.image = imageResult.image
                }

                execute?(
                    nil
                )
            case .failure(let error):
                imageView.image = nil

                execute?(
                    error
                )
            }
        }

        placeholderContainer?.placeholder = placeholder
    }
}

extension URLImageSource {
    public func formOptions() -> KingfisherOptionsInfo {
        var options: KingfisherOptionsInfo = []
        appendDefaultOptions(to: &options)
        appendOptionForForceRefreshIfNeeded(to: &options)
        appendOptionForImageProcessorIfNeeded(to: &options)
        return options
    }

    public func appendDefaultOptions(to options: inout KingfisherOptionsInfo) {
        options.append(.transition(.fade(0.2)))
    }

    public func appendOptionForForceRefreshIfNeeded(to options: inout KingfisherOptionsInfo) {
        if !forceRefresh { return }
        options.append(.forceRefresh)
    }

    public func appendOptionForImageProcessorIfNeeded(to options: inout KingfisherOptionsInfo) {
        guard let processor = formImageProcessors().compactJoined() else { return }
        options.append(.processor(processor))
    }
}
