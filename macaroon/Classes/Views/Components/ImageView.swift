// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ImageView: BaseView, ImageCustomizable, ImageLoadable {
    public var imageContainer: UIImageView {
        return contentView
    }

    private lazy var contentView = UIImageView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func customizeAppearance(_ style: ImageStyling) {
        customizeBaseAppearance(style)

        contentView.contentMode = style.contentMode
        contentView.image = style.image
    }

    open func prepareLayout() {
        addContentView()
    }

    open func addContentView() {
        addSubview(contentView)
        contentView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }

    open override func prepareForReuse() {
        unloadSource()
    }
}
