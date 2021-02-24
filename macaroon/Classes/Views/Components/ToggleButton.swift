// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ToggleButton: BaseControl {
    open override var intrinsicContentSize: CGSize {
        return CGSize.leastTouchMagnitude
    }

    private lazy var imageView = UIImageView()

    private let image: UIImage
    private let selectedImage: UIImage
    private let disabledImage: UIImage?

    public init(
        image: UIImage,
        selectedImage: UIImage,
        disabledImage: UIImage? = nil
    ) {
        self.image = image
        self.selectedImage = selectedImage
        self.disabledImage = disabledImage
        super.init(frame: .zero)
        prepareLayout()
    }

    open override func recustomizeAppearance(for state: UIControl.State) {
        switch state {
        case .selected:
            imageView.image = selectedImage
        case .disabled:
            imageView.image = disabledImage ?? image
        default:
            imageView.image = image
        }
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
        if isEnabled {
            isSelected.toggle()
        }
    }
}
