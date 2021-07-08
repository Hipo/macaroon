// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Customizable where Self: UIImageView {
    public func customizeAppearance(
        _ style: ImageStyle
    ) {
        style.forEach {
            switch $0 {
            case .backgroundColor(let backgroundColor):
                customizeBaseAppearance(
                    backgroundColor: backgroundColor
                )
            case .tintColor(let tintColor):
                customizeBaseAppearance(
                    tintColor: tintColor
                )
            case .isInteractable(let isInteractable):
                customizeBaseAppearance(
                    isInteractable: isInteractable
                )
            case .contentMode(let contentMode):
                customizeBaseAppearance(
                    contentMode: contentMode
                )
            case .adjustsImageForContentSizeCategory(let adjustsImageForContentSizeCategory):
                customizeBaseAppearance(
                    adjustsImageForContentSizeCategory: adjustsImageForContentSizeCategory
                )
            case .content(let content):
                customizeBaseAppearance(
                    content: content
                )
            }
        }
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
            content: nil
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
        adjustsImageForContentSizeCategory: Bool
    ) {
        self.adjustsImageSizeForAccessibilityContentSizeCategory = adjustsImageForContentSizeCategory
    }

    public func customizeBaseAppearance(
        content: Image?
    ) {
        image = content?.image
    }
}
