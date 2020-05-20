// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TextInputCustomizable: Customizable {
    func customizeAppearance(_ style: TextInputStyling)
    func resetAppearance()
}

extension TextInputCustomizable where Self: UITextField {
    public func customizeAppearance(_ style: TextInputStyling) {
        customizeBaseAppearance(style)

        if let background = style.background?.normal {
            self.background = background
        }
        if let background = style.background?.disabled {
            disabledBackground = background
        }
        if let font = style.font?.normal {
            self.font = font.preferred
            self.adjustsFontForContentSizeCategory = font.adjustsFontForContentSizeCategory
        }
        if let textColor = style.textColor?.normal {
            self.textColor = textColor
        }
        textAlignment = style.textAlignment

        if let placeholderText = style.placeholderText {
            switch placeholderText {
            case .normal(let text, _):
                if let textColor = style.placeholderColor?.normal {
                    attributedPlaceholder = text?.attributed(.textColor(textColor))
                } else {
                    placeholder = text
                }
            case .attributed(let attributedText):
                attributedPlaceholder = attributedText
            }
        }
        clearButtonMode = style.clearButtonMode
        keyboardType = style.keyboardType
        autocapitalizationType = style.autocapitalizationType
        autocorrectionType = style.autocorrectionType
        returnKeyType = style.returnKeyType
    }

    public func resetAppearance() {
        resetBaseAppearance()

        background = nil
        disabledBackground = nil
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = false
        textColor = .black
        textAlignment = .left
        attributedPlaceholder = nil
        placeholder = nil
        clearButtonMode = .whileEditing
        keyboardType = .default
        autocapitalizationType = .sentences
        autocorrectionType = .default
        returnKeyType = .default
    }
}

extension UITextField: TextInputCustomizable { }

extension TextInputCustomizable where Self: UITextView {
    public func customizeAppearance(_ style: TextInputStyling) {
        customizeBaseAppearance(style)

        if let font = style.font?.normal {
            self.font = font.preferred
            self.adjustsFontForContentSizeCategory = font.adjustsFontForContentSizeCategory
        }
        if let textColor = style.textColor?.normal {
            self.textColor = textColor
        }
        textAlignment = style.textAlignment
        keyboardType = style.keyboardType
        autocapitalizationType = style.autocapitalizationType
        autocorrectionType = style.autocorrectionType
        returnKeyType = style.returnKeyType
    }

    public func resetAppearance() {
        resetBaseAppearance()

        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = false
        textColor = .black
        textAlignment = .left
        keyboardType = .default
        autocapitalizationType = .sentences
        autocorrectionType = .default
        returnKeyType = .default
    }
}

extension UITextView: TextInputCustomizable { }
