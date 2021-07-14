// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Customizable where Self: UIImageView {
    public func customizeAppearance(
        _ style: ImageStyle
    ) {
        customizeBaseAppearance(image: style.image)
        customizeBaseAppearance(contentMode: style.contentMode)
        customizeBaseAppearance(adjustsImageForContentSizeCategory: style.adjustsImageForContentSizeCategory)
        customizeBaseAppearance(backgroundColor: style.backgroundColor)
        customizeBaseAppearance(tintColor: style.tintColor)
        customizeBaseAppearance(isInteractable: style.isInteractable)
    }

    public func recustomizeAppearance(
        _ style: ImageStyle
    ) {
        resetAppearance()
        customizeAppearance(
            style
        )
    }

    public func resetAppearance() {
        resetBaseAppearance()

        customizeBaseAppearance(
            contentMode: nil
        )
        customizeBaseAppearance(
            adjustsImageForContentSizeCategory: false
        )
        customizeBaseAppearance(
            image: nil
        )
    }
}

extension Customizable where Self: UIImageView {
    public func customizeBaseAppearance(
        contentMode: UIView.ContentMode?
    ) {
        self.contentMode = contentMode ?? .scaleToFill
    }

    public func customizeBaseAppearance(
        adjustsImageForContentSizeCategory: Bool?
    ) {
        self.adjustsImageSizeForAccessibilityContentSizeCategory = adjustsImageForContentSizeCategory ?? false
    }

    public func customizeBaseAppearance(
        image: Image?
    ) {
        self.image = image?.image
    }
}
