// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol StylingModifiable: Styling {
    var modifiers: [StylingModifier] { get }
}

extension StylingModifiable {
    public var modifiers: [StylingModifier] {
        return []
    }
    public var tintColor: ColorGroup? {
        return modifiers.last(\.tintColor)
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.last(\.backgroundColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.last(\.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.last(\.shadow)
    }
}

public protocol ButtonStylingModifiable: ButtonStyling {
    var modifiers: [StylingButtonModifier] { get }
}

extension ButtonStylingModifiable {
    public var modifiers: [StylingButtonModifier] {
        return []
    }
    public var background: ImageGroup? {
        return modifiers.last(\.background)
    }
    public var icon: ImageGroup? {
        return modifiers.last(\.icon)
    }
    public var font: FontGroup? {
        return modifiers.last(\.font)
    }
    public var textColor: ColorGroup? {
        return modifiers.last(\.textColor)
    }
    public var title: TextGroup? {
        return modifiers.last(\.title)
    }
    public var tintColor: ColorGroup? {
        return modifiers.last(\.tintColor)
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.last(\.backgroundColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.last(\.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.last(\.shadow)
    }
}

public protocol ImageStylingModifiable: ImageStyling {
    var modifiers: [StylingImageModifier] { get }
}

extension ImageStylingModifiable {
    public var modifiers: [StylingImageModifier] {
        return []
    }
    public var image: UIImage? {
        return modifiers.last(\.image)
    }
    public var contentMode: UIView.ContentMode {
        return modifiers.last(\.contentMode) ?? .scaleToFill
    }
    public var tintColor: ColorGroup? {
        return modifiers.last(\.tintColor)
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.last(\.backgroundColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.last(\.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.last(\.shadow)
    }
}

public protocol TextStylingModifiable: TextStyling {
    var modifiers: [StylingTextModifier] { get }
}

extension TextStylingModifiable {
    public var modifiers: [StylingTextModifier] {
        return []
    }
    public var font: FontGroup? {
        return modifiers.last(\.font)
    }
    public var textColor: ColorGroup? {
        return modifiers.last(\.textColor)
    }
    public var textAlignment: NSTextAlignment {
        return modifiers.last(\.textAlignment) ?? .left
    }
    public var textOverflow: TextOverflow {
        return modifiers.last(\.textOverflow) ?? .truncated
    }
    public var tintColor: ColorGroup? {
        return modifiers.last(\.tintColor)
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.last(\.backgroundColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.last(\.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.last(\.shadow)
    }
}

public protocol TextInputStylingModifiable: TextInputStyling {
    var modifiers: [StylingTextInputModifier] { get }
}

extension TextInputStylingModifiable {
    var modifiers: [StylingTextInputModifier] {
        return []
    }
    public var background: ImageGroup? {
        return modifiers.last(\.background)
    }
    public var font: FontGroup? {
        return modifiers.last(\.font)
    }
    public var textColor: ColorGroup? {
        return modifiers.last(\.textColor)
    }
    public var textAlignment: NSTextAlignment {
        return modifiers.last(\.textAlignment) ?? .left
    }
    public var placeholderColor: ColorGroup? {
        return modifiers.last(\.placeholderColor)
    }
    public var placeholderText: EditText? {
        return modifiers.last(\.placeholderText)
    }
    public var clearButtonMode: UITextField.ViewMode {
        return modifiers.last(\.clearButtonMode) ?? .whileEditing
    }
    public var keyboardType: UIKeyboardType {
        return modifiers.last(\.keyboardType) ?? .default
    }
    public var autocapitalizationType: UITextAutocapitalizationType {
        return modifiers.last(\.autocapitalizationType) ?? .sentences
    }
    public var autocorrectionType: UITextAutocorrectionType {
        return modifiers.last(\.autocorrectionType) ?? .default
    }
    public var returnKeyType: UIReturnKeyType {
        return modifiers.last(\.returnKeyType) ?? .next
    }
    public var tintColor: ColorGroup? {
        return modifiers.last(\.tintColor)
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.last(\.backgroundColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.last(\.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.last(\.shadow)
    }
}

public protocol StylingModifier: Styling {
    var name: String { get }
}

extension StylingModifier {
    public var name: String {
        return String(describing: Self.self)
    }
}

public protocol StylingButtonModifier: StylingModifier, ButtonStyling { }
public protocol StylingImageModifier: StylingModifier, ImageStyling { }
public protocol StylingTextModifier: StylingModifier, TextStyling { }
public protocol StylingTextInputModifier: StylingModifier, TextInputStyling { }
