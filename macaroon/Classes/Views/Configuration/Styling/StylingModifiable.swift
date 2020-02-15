// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol StylingModifiable: Styling {
    var modifiers: [StylingModifier] { get }
}

extension StylingModifiable {
    public var modifiers: [StylingModifier] {
        return []
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.compactLast(\.backgroundColor)
    }
    public var tintColor: ColorGroup? {
        return modifiers.compactLast(\.tintColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.compactLast(\.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.compactLast(\.shadow)
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
        return modifiers.compactLast(\.background)
    }
    public var icon: ImageGroup? {
        return modifiers.compactLast(\.icon)
    }
    public var font: FontGroup? {
        return modifiers.compactLast(\.font)
    }
    public var textColor: ColorGroup? {
        return modifiers.compactLast(\.textColor)
    }
    public var title: TextGroup? {
        return modifiers.compactLast(\.title)
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.compactLast(\.backgroundColor)
    }
    public var tintColor: ColorGroup? {
        return modifiers.compactLast(\.tintColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.compactLast(\.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.compactLast(\.shadow)
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
        return modifiers.compactLast(\.image)
    }
    public var contentMode: UIView.ContentMode {
        return modifiers.compactLast(\.contentMode) ?? .scaleToFill
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.compactLast(\.backgroundColor)
    }
    public var tintColor: ColorGroup? {
        return modifiers.compactLast(\.tintColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.compactLast(\.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.compactLast(\.shadow)
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
        return modifiers.compactLast(\.font)
    }
    public var textColor: ColorGroup? {
        return modifiers.compactLast(\.textColor)
    }
    public var textAlignment: NSTextAlignment {
        return modifiers.compactLast(\.textAlignment) ?? .left
    }
    public var textOverflow: TextOverflow {
        return modifiers.compactLast(\.textOverflow) ?? .truncated
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.compactLast(\.backgroundColor)
    }
    public var tintColor: ColorGroup? {
        return modifiers.compactLast(\.tintColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.compactLast(\.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.compactLast(\.shadow)
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
        return modifiers.compactLast(\.background)
    }
    public var font: FontGroup? {
        return modifiers.compactLast(\.font)
    }
    public var textColor: ColorGroup? {
        return modifiers.compactLast(\.textColor)
    }
    public var textAlignment: NSTextAlignment {
        return modifiers.compactLast(\.textAlignment) ?? .left
    }
    public var placeholderColor: ColorGroup? {
        return modifiers.compactLast(\.placeholderColor)
    }
    public var placeholderText: EditText? {
        return modifiers.compactLast(\.placeholderText)
    }
    public var clearButtonMode: UITextField.ViewMode {
        return modifiers.compactLast(\.clearButtonMode) ?? .whileEditing
    }
    public var keyboardType: UIKeyboardType {
        return modifiers.compactLast(\.keyboardType) ?? .default
    }
    public var autocapitalizationType: UITextAutocapitalizationType {
        return modifiers.compactLast(\.autocapitalizationType) ?? .sentences
    }
    public var autocorrectionType: UITextAutocorrectionType {
        return modifiers.compactLast(\.autocorrectionType) ?? .default
    }
    public var returnKeyType: UIReturnKeyType {
        return modifiers.compactLast(\.returnKeyType) ?? .next
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.compactLast(\.backgroundColor)
    }
    public var tintColor: ColorGroup? {
        return modifiers.compactLast(\.tintColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.compactLast(\.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.compactLast(\.shadow)
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
