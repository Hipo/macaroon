// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UIView {
    public func customizeBaseAppearance(_ style: Styling) {
        if let tintColor = style.tintColor?.normal {
            self.tintColor = tintColor
        }
        if let backgroundColor = style.backgroundColor?.normal {
            self.backgroundColor = backgroundColor
        }
    }
}

extension UIView: CornerRoundDrawable { }

extension UIImageView {
    public func customizeAppearance(_ style: ImageStyling) {
        customizeBaseAppearance(style)

        contentMode = style.contentMode
        image = style.image
    }
}

extension UILabel {
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

        switch style.textOverflow {
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
}

extension UIButton {
    public func customizeAppearance(_ style: ButtonStyling) {
        customizeBaseAppearance(style)

        if let background = style.background?.normal {
            setBackgroundImage(background, for: .normal)
        }
        if let background = style.background?.highlighted {
            setBackgroundImage(background, for: .highlighted)
        }
        if let background = style.background?.selected {
            setBackgroundImage(background, for: .selected)
        }
        if let background = style.background?.disabled {
            setBackgroundImage(background, for: .disabled)
        }
        if let icon = style.icon?.normal {
            setImage(icon, for: .normal)
        }
        if let icon = style.icon?.highlighted {
            setImage(icon, for: .highlighted)
        }
        if let icon = style.icon?.selected {
            setImage(icon, for: .selected)
        }
        if let icon = style.icon?.disabled {
            setImage(icon, for: .disabled)
        }
        if let font = style.font?.normal {
            titleLabel?.font = font.preferred
            titleLabel?.adjustsFontSizeToFitWidth = true
        }
        if let textColor = style.textColor?.normal {
            setTitleColor(textColor, for: .normal)
        }
        if let textColor = style.textColor?.highlighted {
            setTitleColor(textColor, for: .highlighted)
        }
        if let textColor = style.textColor?.selected {
            setTitleColor(textColor, for: .selected)
        }
        if let textColor = style.textColor?.disabled {
            setTitleColor(textColor, for: .disabled)
        }
        if let title = style.title?.normal {
            setEditTitle(title, for: .normal)
        }
        if let title = style.title?.highlighted {
            setEditTitle(title, for: .highlighted)
        }
        if let title = style.title?.selected {
            setEditTitle(title, for: .selected)
        }
        if let title = style.title?.disabled {
            setEditTitle(title, for: .disabled)
        }
    }
}

extension UITextField {
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
            case .normal(let text):
                if let textColor = style.placeholderColor?.normal {
                    attributedPlaceholder = text.attributed(.textColor(textColor))
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
}

extension UITextView {
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
}

extension UINavigationBar {
    public func customizeBarAppearance(_ style: TextStyling) {
        if let tintColor = style.tintColor?.normal {
            self.tintColor = tintColor
        }
        if let backgroundColor = style.backgroundColor?.normal {
            self.barTintColor = backgroundColor
        }

        var titleTextAttributes: [NSAttributedString.Key: Any] = [:]

        if let textColor = style.textColor?.normal {
            titleTextAttributes[.foregroundColor] = textColor
        }
        if let font = style.font?.normal {
            titleTextAttributes[.font] = font.preferred
        }
        self.titleTextAttributes = titleTextAttributes
    }
}

public protocol CornerRoundDrawable: UIView { }

extension CornerRoundDrawable {
    public func customizeCornerRoundAppearance(_ cornerRound: CornerRound) {
        layer.cornerRadius = cornerRound.radius

        if let corners = cornerRound.corners {
            layer.maskedCorners = corners
        }
        layer.masksToBounds = true
    }
}

public protocol ShadowDrawable: UIView {
    var shadowLayer: CAShapeLayer { get }
}

extension ShadowDrawable {
    public func customizeShadowAppearance(_ shadow: Shadow) {
        shadowLayer.shadowColor = shadow.color.cgColor
        shadowLayer.fillColor = shadow.fillColor.cgColor
        shadowLayer.shadowOpacity = shadow.opacity
        shadowLayer.shadowOffset = shadow.offset
        shadowLayer.shadowRadius = shadow.radius
        shadowLayer.masksToBounds = false
    }

    public func recustomizeShadowAppearanceWhenViewDidLayoutSubviews(_ shadow: Shadow) {
        if bounds.isEmpty {
            return
        }
        shadowLayer.frame = bounds

        if shadow.hasRoundCorners() {
            shadowLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: shadow.corners, cornerRadii: shadow.cornerRadii).cgPath
        } else {
            shadowLayer.path = UIBezierPath(rect: bounds).cgPath
        }
    }
}
