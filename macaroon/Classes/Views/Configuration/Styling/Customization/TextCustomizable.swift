// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TextCustomizable: Customizable {
    func customizeAppearance(_ style: TextStyling)
    func resetAppearance()
}

extension TextCustomizable where Self: UILabel {
    public func customizeAppearance(_ style: TextStyling) {
        customizeBaseAppearance(style)
        customizeAppearance(style.textOverflow)

        if let font = style.font?.normal {
            customizeAppearance(font)
        }
        if let textColor = style.textColor?.normal {
            self.textColor = textColor
        }
        if let editText = style.text?.normal {
            self.editText = editText
        }
        textAlignment = style.textAlignment
    }

    public func customizeAppearance(_ font: Font) {
        self.font = font.preferred
        self.adjustsFontForContentSizeCategory = font.adjustsFontForContentSizeCategory
    }

    public func customizeAppearance(_ textOverflow: TextOverflow) {
        switch textOverflow {
        case .truncated:
            numberOfLines = 1
            lineBreakMode = .byTruncatingTail
        case .singleLine(let mode):
            numberOfLines = 1
            lineBreakMode = mode
        case .singleLineFitting:
            numberOfLines = 1
            lineBreakMode = .byTruncatingTail
            adjustsFontSizeToFitWidth = true
            minimumScaleFactor = 0.5
        case .multiline(let line, let mode):
            numberOfLines = line
            lineBreakMode = mode
        case .multilineFitting(let line, let mode):
            numberOfLines = line
            lineBreakMode = mode
            adjustsFontSizeToFitWidth = true
            minimumScaleFactor = 0.5
        case .fitting:
            numberOfLines = 0
            lineBreakMode = .byWordWrapping
        }
    }

    public func resetAppearance() {
        resetBaseAppearance()
        customizeAppearance(.truncated)

        font = nil
        adjustsFontForContentSizeCategory = false
        textAlignment = .left
        editText = nil
    }
}

extension UILabel: TextCustomizable { }

extension TextCustomizable where Self: UITextField {
    public func customizeAppearance(_ style: TextStyling) {
        customizeBaseAppearance(style)

        if let font = style.font?.normal {
            self.font = font.preferred
            self.adjustsFontForContentSizeCategory = font.adjustsFontForContentSizeCategory
        }
        if let textColor = style.textColor?.normal {
            self.textColor = textColor
        }
        textAlignment = style.textAlignment
        tintColor = .clear
    }
}

extension UITextField: TextCustomizable { }
