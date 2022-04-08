// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import SnapKit
import UIKit

open class URLImageView:
    View,
    URLImageLoadable {
    open override var tintColor: UIColor! {
        get { contentView.tintColor }
        set { contentView.tintColor = newValue }
    }

    public var imageContainer: UIImageView {
        return contentView
    }
    public var placeholderContainer: URLImagePlaceholderContainer? {
        return placeholderView
    }

    private(set) lazy var contentView = UIImageView()
    private(set) lazy var placeholderView = URLImagePlaceholderView()

    open func build(
        _ sheet: URLImageViewStyleSheet & URLImageViewLayoutSheet
    ) {
        customizeAppearance(
            sheet
        )
        prepareLayout(
            sheet
        )
    }

    open func customizeAppearance(
        _ styleSheet: URLImageViewStyleSheet
    ) {
        customizeAppearance(
            styleSheet.background
        )
        customizeContentAppearance(
            styleSheet
        )
        customizePlaceholderAppearance(
            styleSheet
        )
    }

    open func customizeContentAppearance(
        _ styleSheet: URLImageViewStyleSheet
    ) {
        contentView.customizeAppearance(
            styleSheet.content
        )
    }

    open func customizePlaceholderAppearance(
        _ styleSheet: URLImageViewStyleSheet
    ) {
        if let placeholder = styleSheet.placeholderStyleSheet {
            placeholderView.customizeAppearance(
                placeholder
            )
        }
    }

    open func prepareLayout(
        _ layoutSheet: URLImageViewLayoutSheet
    ) {
        addContent(
            layoutSheet
        )

        if let placeholder = layoutSheet.placeholderLayoutSheet {
            placeholderView.prepareLayout(
                placeholder
            )
        }
    }

    open func addContent(
        _ layoutSheet: URLImageViewLayoutSheet
    ) {
        addSubview(
            contentView
        )
        contentView.snp.makeConstraints {
            $0.setPaddings()
        }
    }

    open func prepareForReuse() {
        unloadSource()
        placeholderView.prepareForReuse()
    }
}
