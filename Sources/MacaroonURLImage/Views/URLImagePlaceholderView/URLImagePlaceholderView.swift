// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import SnapKit
import UIKit

open class URLImagePlaceholderView:
    View,
    URLImagePlaceholderContainer {
    public var placeholder: ImagePlaceholder? {
        didSet {
            bindData()
        }
    }

    public private(set) lazy var imageView = UIImageView()
    public private(set) lazy var textView = Label()
    
    open func build(
        _ sheet: URLImagePlaceholderViewStyleSheet & URLImagePlaceholderViewLayoutSheet
    ) {
        customizeAppearance(
            sheet
        )
        prepareLayout(
            sheet
        )
    }
    
    open func customizeAppearance(
        _ styleSheet: URLImagePlaceholderViewStyleSheet
    ) {
        customizeAppearance(
            styleSheet.background
        )
        customizeImageAppearance(
            styleSheet
        )
        customizeTextAppearance(
            styleSheet
        )
    }

    open func customizeImageAppearance(
        _ styleSheet: URLImagePlaceholderViewStyleSheet
    ) {
        imageView.customizeAppearance(
            styleSheet.image
        )
    }

    open func customizeTextAppearance(
        _ styleSheet: URLImagePlaceholderViewStyleSheet
    ) {
        textView.customizeAppearance(
            styleSheet.text
        )
    }

    open func prepareLayout(
        _ layoutSheet: URLImagePlaceholderViewLayoutSheet
    ) {
        addImage(
            layoutSheet
        )
        addText(
            layoutSheet
        )
    }

    open func addImage(
        _ layoutSheet: URLImagePlaceholderViewLayoutSheet
    ) {
        addSubview(
            imageView
        )
        imageView.snp.makeConstraints {
            $0.setPaddings()
        }
    }

    open func addText(
        _ layoutSheet: URLImagePlaceholderViewLayoutSheet
    ) {
        addSubview(
            textView
        )
        textView.fitToHorizontalIntrinsicSize()
        textView.fitToVerticalIntrinsicSize()
        textView.snp.makeConstraints {
            $0.setPaddings(
                layoutSheet.textPaddings
            )
        }
    }

    open func bindData() {
        imageView.load(
            from: placeholder?.image
        )
        textView.editText = placeholder?.text
        textView.invalidateIntrinsicContentSize()
    }

    open func prepareForReuse() {
        imageView.image = nil
        textView.editText = nil
    }
}
