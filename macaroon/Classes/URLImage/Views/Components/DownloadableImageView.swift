// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class DownloadableImageView: ImageView, URLImageLoadable {
    open override var tintColor: UIColor! {
        get {
            return imageContainer.tintColor
        }
        set {
            imageContainer.tintColor = newValue
        }
    }

    public var placeholderContainer: URLImagePlaceholderContainer? {
        return placeholderView
    }

    private lazy var placeholderView = DownloadableImagePlaceholderView()

    open func customizeAppearance(_ style: DownloadableImageStyling) {
        super.customizeAppearance(style)

        if let placeholder = style.placeholder {
            placeholderView.customizeAppearance(placeholder)
        }
    }

    open func load(from source: ImageSource) {
        if let urlSource = source as? PNGImageSource {
            return
        }
        super.load(from: source)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        placeholderView.prepareForReuse()
    }
}
