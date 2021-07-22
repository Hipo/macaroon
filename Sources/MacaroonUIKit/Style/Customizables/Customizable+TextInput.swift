// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Customizable where Self: UITextField {
    public func customizeAppearance(
        _ style: TextInputStyle
    ) {
        customizeBaseAppearance(font: style.font)
        customizeBaseAppearance(textColor: style.textColor)
        customizeBaseAppearance(textAlignment: style.textAlignment)
        customizeBaseAppearance(textContentType: style.textContentType)
        customizeBaseAppearance(text: style.text)
        customizeBaseAppearance(
            placeholder: style.placeholder,
            placeholderColor: style.placeholderColor
        )
        customizeBaseAppearance(clearButtonMode: style.clearButtonMode)
        customizeBaseAppearance(keyboardType: style.keyboardType)
        customizeBaseAppearance(returnKeyType: style.returnKeyType)
        customizeBaseAppearance(autocapitalizationType: style.autocapitalizationType)
        customizeBaseAppearance(autocorrectionType: style.autocorrectionType)
        customizeBaseAppearance(backgroundImage: style.backgroundImage)
        customizeBaseAppearance(backgroundColor: style.backgroundColor)
        customizeBaseAppearance(tintColor: style.tintColor)
        customizeBaseAppearance(isInteractable: style.isInteractable)
    }

    public func recustomizeAppearance(
        _ style: TextInputStyle
    ) {
        resetAppearance()
        customizeAppearance(
            style
        )
    }

    public func resetAppearance() {
        resetBaseAppearance()

        customizeBaseAppearance(
            backgroundImage: nil
        )
        customizeBaseAppearance(
            font: nil
        )
        customizeBaseAppearance(
            textAlignment: nil
        )
        customizeBaseAppearance(
            textColor: nil
        )
        customizeBaseAppearance(
            text: nil
        )
        customizeBaseAppearance(
            placeholder: nil,
            placeholderColor: nil
        )
        customizeBaseAppearance(
            clearButtonMode: nil
        )
        customizeBaseAppearance(
            keyboardType: nil
        )
        customizeBaseAppearance(
            returnKeyType: nil
        )
        customizeBaseAppearance(
            autocapitalizationType: nil
        )
        customizeBaseAppearance(
            autocorrectionType: nil
        )
        customizeBaseAppearance(
            textContentType: nil
        )
    }
}

extension Customizable where Self: UITextField {
    public func customizeBaseAppearance(
        backgroundImage: Image?
    ) {
        background = backgroundImage?.uiImage
    }

    public func customizeBaseAppearance(
        disabledBackgroundImage: Image?
    ) {
        disabledBackground = disabledBackgroundImage?.uiImage
    }

    public func customizeBaseAppearance(
        font: Font?
    ) {
        self.font = font?.uiFont
    }

    public func customizeBaseAppearance(
        textAlignment: NSTextAlignment?
    ) {
        self.textAlignment = textAlignment ?? .left
    }

    public func customizeBaseAppearance(
        textColor: Color?
    ) {
        self.textColor = textColor?.uiColor ?? .black
    }

    public func customizeBaseAppearance(
        text: Text?
    ) {
        self.editText = text?.text
    }

    public func customizeBaseAppearance(
        placeholder: Text?,
        placeholderColor: Color?
    ) {
        guard let placeholder = placeholder else {
            self.placeholder = nil
            self.attributedPlaceholder = nil

            return
        }

        switch placeholder.text {
        case .string(let string, _):
            if let placeholderColor = placeholderColor {
                self.attributedPlaceholder =
                    string?.attributed(
                        .textColor(placeholderColor.uiColor)
                    )
            } else {
                self.placeholder = string
            }
        case .attributedString(let attributedString):
            if let placeholderColor = placeholderColor {
                let mAttributedString =
                    NSMutableAttributedString(attributedString: attributedString)
                mAttributedString.addAttribute(
                    .foregroundColor,
                    value: placeholderColor.uiColor,
                    range: NSRange(location: 0, length: attributedString.length)
                )

                self.attributedPlaceholder = mAttributedString
            } else {
                self.attributedPlaceholder = attributedString
            }
        }
    }

    public func customizeBaseAppearance(
        clearButtonMode: UITextField.ViewMode?
    ) {
        self.clearButtonMode = clearButtonMode ?? .never
    }

    public func customizeBaseAppearance(
        keyboardType: UIKeyboardType?
    ) {
        self.keyboardType = keyboardType ?? .default
    }

    public func customizeBaseAppearance(
        returnKeyType: UIReturnKeyType?
    ) {
        self.returnKeyType = returnKeyType ?? .default
    }

    public func customizeBaseAppearance(
        autocapitalizationType: UITextAutocapitalizationType?
    ) {
        self.autocapitalizationType = autocapitalizationType ?? .sentences
    }

    public func customizeBaseAppearance(
        autocorrectionType: UITextAutocorrectionType?
    ) {
        self.autocorrectionType = autocorrectionType ?? .default
    }

    public func customizeBaseAppearance(
        textContentType: UITextContentType?
    ) {
        self.textContentType = textContentType
    }
}

extension Customizable where Self: UITextView {
    public func customizeAppearance(
        _ style: TextInputStyle
    ) {
        customizeBaseAppearance(font: style.font)
        customizeBaseAppearance(textColor: style.textColor)
        customizeBaseAppearance(textAlignment: style.textAlignment)
        customizeBaseAppearance(textContentType: style.textContentType)
        customizeBaseAppearance(text: style.text)
        customizeBaseAppearance(keyboardType: style.keyboardType)
        customizeBaseAppearance(returnKeyType: style.returnKeyType)
        customizeBaseAppearance(autocapitalizationType: style.autocapitalizationType)
        customizeBaseAppearance(autocorrectionType: style.autocorrectionType)
        customizeBaseAppearance(backgroundColor: style.backgroundColor)
        customizeBaseAppearance(tintColor: style.tintColor)
        customizeBaseAppearance(isInteractable: style.isInteractable)
    }

    public func recustomizeAppearance(
        _ style: TextInputStyle
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
            textAlignment: nil
        )
        customizeBaseAppearance(
            textColor: nil
        )
        customizeBaseAppearance(
            text: nil
        )
        customizeBaseAppearance(
            keyboardType: nil
        )
        customizeBaseAppearance(
            returnKeyType: nil
        )
        customizeBaseAppearance(
            autocapitalizationType: nil
        )
        customizeBaseAppearance(
            autocorrectionType: nil
        )
        customizeBaseAppearance(
            textContentType: nil
        )
    }
}

extension Customizable where Self: UITextView {
    public func customizeBaseAppearance(
        font: Font?
    ) {
        self.font = font?.uiFont
    }

    public func customizeBaseAppearance(
        textAlignment: NSTextAlignment?
    ) {
        self.textAlignment = textAlignment ?? .left
    }

    public func customizeBaseAppearance(
        textColor: Color?
    ) {
        self.textColor = textColor?.uiColor ?? .black
    }

    public func customizeBaseAppearance(
        text: Text?
    ) {
        self.editText = text?.text
    }

    public func customizeBaseAppearance(
        keyboardType: UIKeyboardType?
    ) {
        self.keyboardType = keyboardType ?? .default
    }

    public func customizeBaseAppearance(
        returnKeyType: UIReturnKeyType?
    ) {
        self.returnKeyType = returnKeyType ?? .default
    }

    public func customizeBaseAppearance(
        autocapitalizationType: UITextAutocapitalizationType?
    ) {
        self.autocapitalizationType = autocapitalizationType ?? .sentences
    }

    public func customizeBaseAppearance(
        autocorrectionType: UITextAutocorrectionType?
    ) {
        self.autocorrectionType = autocorrectionType ?? .default
    }

    public func customizeBaseAppearance(
        textContentType: UITextContentType?
    ) {
        self.textContentType = textContentType
    }
}
