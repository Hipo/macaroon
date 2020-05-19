// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ImageView: BaseView, ImageCustomizable, ImageLoadable {
    open override var tintColor: UIColor! {
        get { return contentView.tintColor }
        set { contentView.tintColor = newValue }
    }

    public var imageContainer: UIImageView {
        return contentView
    }

    private lazy var contentView = UIImageView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }

    open func customizeAppearance(_ style: ImageStyling) {
        customizeBaseAppearance(style)

        contentView.contentMode = style.contentMode
        contentView.image = style.image
    }

    public func resetAppearance() {
        resetBaseAppearance()

        contentView.contentMode = .scaleToFill
        contentView.image = nil
    }

    open func prepareLayout() {
        addContentView()
    }

    open override func prepareForReuse() {
        unloadSource()
    }
}

extension ImageView {
    private func addContentView() {
        addSubview(contentView)
        contentView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
}
