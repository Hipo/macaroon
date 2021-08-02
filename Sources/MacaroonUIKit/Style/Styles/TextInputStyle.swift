// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct TextInputStyle: BaseStyle {
    public var font: Font?
    public var textColor: Color?
    public var textAlignment: NSTextAlignment?
    public var textContentType: UITextContentType?
    public var text: Text?
    public var placeholder: Text?
    public var placeholderColor: Color?
    public var clearButtonMode: UITextField.ViewMode?
    public var keyboardType: UIKeyboardType?
    public var returnKeyType: UIReturnKeyType?
    public var autocapitalizationType: UITextAutocapitalizationType?
    public var autocorrectionType: UITextAutocorrectionType?
    public var backgroundImage: Image?
    public var disabledBackgroundImage: Image?
    public var backgroundColor: Color?
    public var tintColor: Color?
    public var isSecure: Bool?
    public var isInteractable: Bool?

    public init(
        attributes: [Attribute]
    ) {
        attributes.forEach {
            switch $0 {
            case .font(let font): self.font = font
            case .textColor(let textColor): self.textColor = textColor
            case .textAlignment(let textAlignment): self.textAlignment = textAlignment
            case .textContentType(let textContentType): self.textContentType = textContentType
            case .text(let text): self.text = text
            case .placeholder(let placeholder): self.placeholder = placeholder
            case .placeholderColor(let placeholderColor): self.placeholderColor = placeholderColor
            case .clearButtonMode(let clearButtonMode): self.clearButtonMode = clearButtonMode
            case .keyboardType(let keyboardType): self.keyboardType = keyboardType
            case .returnKeyType(let returnKeyType): self.returnKeyType = returnKeyType
            case .autocapitalizationType(let autocapitalizationType): self.autocapitalizationType = autocapitalizationType
            case .autocorrectionType(let autocorrectionType): self.autocorrectionType = autocorrectionType
            case .backgroundImage(let backgroundImage): self.backgroundImage = backgroundImage
            case .disabledBackgroundImage(let disabledBackgroundImage): self.disabledBackgroundImage = disabledBackgroundImage
            case .backgroundColor(let backgroundColor): self.backgroundColor = backgroundColor
            case .tintColor(let tintColor): self.tintColor = tintColor
            case .isSecure(let isSecure): self.isSecure = isSecure
            case .isInteractable(let interactable): self.isInteractable = interactable
            }
        }
    }
}

extension TextInputStyle {
    public func modify(
        _ modifiers: TextInputStyle...
    ) -> TextInputStyle {
        var modifiedStyle = TextInputStyle()
        modifiedStyle.font = modifiers.last(existing: \.font) ?? font
        modifiedStyle.textColor = modifiers.last(existing: \.textColor) ?? textColor
        modifiedStyle.textAlignment = modifiers.last(existing: \.textAlignment) ?? textAlignment
        modifiedStyle.textContentType = modifiers.last(existing: \.textContentType) ?? textContentType
        modifiedStyle.text = modifiers.last(existing: \.text) ?? text
        modifiedStyle.placeholder = modifiers.last(existing: \.placeholder) ?? placeholder
        modifiedStyle.placeholderColor = modifiers.last(existing: \.placeholderColor) ?? placeholderColor
        modifiedStyle.clearButtonMode = modifiers.last(existing: \.clearButtonMode) ?? clearButtonMode
        modifiedStyle.keyboardType = modifiers.last(existing: \.keyboardType) ?? keyboardType
        modifiedStyle.returnKeyType = modifiers.last(existing: \.returnKeyType) ?? returnKeyType
        modifiedStyle.autocapitalizationType = modifiers.last(existing: \.autocapitalizationType) ?? autocapitalizationType
        modifiedStyle.autocorrectionType = modifiers.last(existing: \.autocorrectionType) ?? autocorrectionType
        modifiedStyle.backgroundImage = modifiers.last(existing: \.backgroundImage) ?? backgroundImage
        modifiedStyle.disabledBackgroundImage = modifiers.last(existing: \.disabledBackgroundImage) ?? disabledBackgroundImage
        modifiedStyle.backgroundColor = modifiers.last(existing: \.backgroundColor) ?? backgroundColor
        modifiedStyle.tintColor = modifiers.last(existing: \.tintColor) ?? tintColor
        modifiedStyle.isSecure = modifiers.last(existing: \.isSecure) ?? isSecure ?? isSecure
        modifiedStyle.isInteractable = modifiers.last(existing: \.isInteractable) ?? isInteractable
        return modifiedStyle
    }
}

extension TextInputStyle {
    public enum Attribute: BaseStyleAttribute {
        case font(Font)
        case textColor(Color)
        case textAlignment(NSTextAlignment)
        case textContentType(UITextContentType)
        case text(Text)
        case placeholder(Text)
        case placeholderColor(Color)
        case clearButtonMode(UITextField.ViewMode)
        case keyboardType(UIKeyboardType)
        case returnKeyType(UIReturnKeyType)
        case autocapitalizationType(UITextAutocapitalizationType)
        case autocorrectionType(UITextAutocorrectionType)
        case backgroundImage(Image)
        case disabledBackgroundImage(Image)
        case backgroundColor(Color)
        case tintColor(Color)
        case isSecure(Bool)
        case isInteractable(Bool)
    }
}
