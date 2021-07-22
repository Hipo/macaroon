// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Customizable where Self: UILabel {
    public func customizeAppearance(
        _ style: TextStyle
    ) {
        customizeBaseAppearance(font: style.font)
        customizeBaseAppearance(adjustsFontForContentSizeCategory: style.adjustsFontForContentSizeCategory)
        customizeBaseAppearance(textColor: style.textColor)
        customizeBaseAppearance(textAlignment: style.textAlignment)
        customizeBaseAppearance(textOverflow: style.textOverflow)
        customizeBaseAppearance(text: style.text)
        customizeBaseAppearance(backgroundColor: style.backgroundColor)
        customizeBaseAppearance(tintColor: style.tintColor)
        customizeBaseAppearance(isInteractable: style.isInteractable)
    }

    public func recustomizeAppearance(
        _ style: TextStyle
    ) {
        resetAppearance()
        customizeAppearance(
            style
        )
    }

    public func resetAppearance() {
        resetBaseAppearance()

        customizeBaseAppearance(
            font: nil
        )
        customizeBaseAppearance(
            adjustsFontForContentSizeCategory: nil
        )
        customizeBaseAppearance(
            textAlignment: nil
        )
        customizeBaseAppearance(
            textOverflow: nil
        )
        customizeBaseAppearance(
            textColor: nil
        )
        customizeBaseAppearance(
            text: nil
        )
    }
}

extension Customizable where Self: UILabel {
    public func customizeBaseAppearance(
        font: Font?
    ) {
        self.font = font?.uiFont
    }

    public func customizeBaseAppearance(
        adjustsFontForContentSizeCategory: Bool?
    ) {
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory ?? false
    }

    public func customizeBaseAppearance(
        textAlignment: NSTextAlignment?
    ) {
        self.textAlignment = textAlignment ?? .left
    }

    public func customizeBaseAppearance(
        textOverflow: TextOverflow?
    ) {
        self.numberOfLines = textOverflow?.numberOfLines ?? 1
        self.lineBreakMode = textOverflow?.lineBreakMode ?? .byTruncatingTail
        self.adjustsFontSizeToFitWidth = textOverflow?.adjustFontSizeToFitWidth ?? false
        self.minimumScaleFactor = textOverflow?.minimumScaleFactor ?? 0
    }

    public func customizeBaseAppearance(
        textColor: Color?
    ) {
        self.textColor = textColor?.uiColor
    }

    public func customizeBaseAppearance(
        text: Text?
    ) {
        self.editText = text?.text
    }
}

extension Customizable where Self: UITextField {
    public func customizeAppearance(
        _ style: TextStyle
    ) {
        customizeBaseAppearance(font: style.font)
        customizeBaseAppearance(adjustsFontForContentSizeCategory: style.adjustsFontForContentSizeCategory)
        customizeBaseAppearance(textColor: style.textColor)
        customizeBaseAppearance(textAlignment: style.textAlignment)
        customizeBaseAppearance(text: style.text)
        customizeBaseAppearance(backgroundColor: style.backgroundColor)
        customizeBaseAppearance(tintColor: style.tintColor)
        customizeBaseAppearance(isInteractable: style.isInteractable)
    }

    public func recustomizeAppearance(
        _ style: TextStyle
    ) {
        resetAppearance()
        customizeAppearance(
            style
        )
    }
}

extension Customizable where Self: UITextField {
    public func customizeBaseAppearance(
        adjustsFontForContentSizeCategory: Bool?
    ) {
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory ?? false
    }
}
