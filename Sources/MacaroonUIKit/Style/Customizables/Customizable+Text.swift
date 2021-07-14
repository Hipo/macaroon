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
        self.font = font?.font
        self.adjustsFontForContentSizeCategory = font?.adjustsFontForContentSizeCategory ?? false
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
        guard let textOverflow = textOverflow else {
            customizeBaseAppearance(
                textOverflow: .singleLine()
            )
            return
        }

        switch textOverflow {
        case .singleLine(let lineBreakMode):
            self.numberOfLines = 1
            self.lineBreakMode = lineBreakMode
        case .singleLineFitting:
            self.numberOfLines = 1
            self.lineBreakMode = .byTruncatingTail
            self.adjustsFontSizeToFitWidth = true
            self.minimumScaleFactor = 0.5
        case .multiline(let maxNumberOfLines, let lineBreakMode):
            self.numberOfLines = maxNumberOfLines
            self.lineBreakMode = lineBreakMode
        case .fitting:
            self.numberOfLines = 0
            self.lineBreakMode = .byWordWrapping
        }
    }

    public func customizeBaseAppearance(
        textColor: Color?
    ) {
        self.textColor = textColor?.color
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
