// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class DownloadableImageView: BaseView, URLImageLoadable {
    open override var tintColor: UIColor! {
        get { return contentView.tintColor }
        set { contentView.tintColor = newValue }
    }

    public var imageContainer: UIImageView {
        return contentView
    }
    public var placeholderContainer: URLImagePlaceholderContainer? {
        return placeholderView
    }

    private lazy var contentView = UIImageView()
    private lazy var placeholderView = DownloadableImagePlaceholderView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }

    open func customizeAppearance(_ style: ImageStyling) {
        customizeBaseAppearance(style)

        contentView.contentMode = style.contentMode
        contentView.image = style.image
    }

    open func customizeAppearance(_ style: DownloadableImageStyling) {
        customizeBaseAppearance(style)

        contentView.contentMode = style.contentMode
        contentView.image = style.image

        if let placeholder = style.placeholder {
            placeholderView.customizeAppearance(placeholder)
        }
    }

    open func resetAppearance() {
        resetBaseAppearance()

        contentView.contentMode = .scaleToFill
        contentView.image = nil
    }

    open func prepareLayout() {
        addContent()
    }

    open func prepareForReuse() {
        unloadSource()
        placeholderView.prepareForReuse()
    }
}

extension DownloadableImageView {
    private func addContent() {
        addSubview(contentView)
        contentView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
}
