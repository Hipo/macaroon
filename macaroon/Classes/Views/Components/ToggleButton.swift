// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ToggleButton: BaseControl {
    open override var isSelected: Bool {
        didSet {
            recustomizeAppearanceWhenSelectedStateChanged()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize.leastTouchMagnitude
    }

    private lazy var imageView = UIImageView()

    private let image: UIImage
    private let selectedImage: UIImage

    public init(
        image: UIImage,
        selectedImage: UIImage
    ) {
        self.image = image
        self.selectedImage = selectedImage

        super.init(frame: .zero)

        customizeAppearance()
        prepareLayout()
    }

    private func customizeAppearance() {
        recustomizeAppearanceWhenSelectedStateChanged()
    }

    private func recustomizeAppearanceWhenSelectedStateChanged() {
        imageView.image = isSelected ? selectedImage : image
    }

    private func prepareLayout() {
        addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.top.greaterThanOrEqualToSuperview()
            maker.leading.greaterThanOrEqualToSuperview()
            maker.bottom.lessThanOrEqualToSuperview()
            maker.trailing.lessThanOrEqualToSuperview()
        }
    }
}

extension ToggleButton {
    public func toggle() {
        isSelected.toggle()
    }
}
