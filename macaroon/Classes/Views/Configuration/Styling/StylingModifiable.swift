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
        return modifiers.findLast(nonNil: \.backgroundColor)
    }
    public var tintColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.tintColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.findLast(nonNil: \.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.findLast(nonNil: \.shadow)
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
        return modifiers.findLast(nonNil: \.background)
    }
    public var icon: ImageGroup? {
        return modifiers.findLast(nonNil: \.icon)
    }
    public var font: FontGroup? {
        return modifiers.findLast(nonNil: \.font)
    }
    public var textColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.textColor)
    }
    public var title: TextGroup? {
        return modifiers.findLast(nonNil: \.title)
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.backgroundColor)
    }
    public var tintColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.tintColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.findLast(nonNil: \.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.findLast(nonNil: \.shadow)
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
        return modifiers.findLast(nonNil: \.image)
    }
    public var contentMode: UIView.ContentMode {
        return modifiers.findLast(nonNil: \.contentMode) ?? .scaleToFill
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.backgroundColor)
    }
    public var tintColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.tintColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.findLast(nonNil: \.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.findLast(nonNil: \.shadow)
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
        return modifiers.findLast(nonNil: \.font)
    }
    public var textColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.textColor)
    }
    public var textAlignment: NSTextAlignment {
        return modifiers.findLast(nonNil: \.textAlignment) ?? .left
    }
    public var textOverflow: TextOverflow {
        return modifiers.findLast(nonNil: \.textOverflow) ?? .truncated
    }
    public var text: TextGroup? {
        return modifiers.findLast(nonNil: \.text)
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.backgroundColor)
    }
    public var tintColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.tintColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.findLast(nonNil: \.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.findLast(nonNil: \.shadow)
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
        return modifiers.findLast(nonNil: \.background)
    }
    public var font: FontGroup? {
        return modifiers.findLast(nonNil: \.font)
    }
    public var textColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.textColor)
    }
    public var textAlignment: NSTextAlignment {
        return modifiers.findLast(nonNil: \.textAlignment) ?? .left
    }
    public var placeholderColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.placeholderColor)
    }
    public var placeholderText: EditText? {
        return modifiers.findLast(nonNil: \.placeholderText)
    }
    public var clearButtonMode: UITextField.ViewMode {
        return modifiers.findLast(nonNil: \.clearButtonMode) ?? .whileEditing
    }
    public var keyboardType: UIKeyboardType {
        return modifiers.findLast(nonNil: \.keyboardType) ?? .default
    }
    public var autocapitalizationType: UITextAutocapitalizationType {
        return modifiers.findLast(nonNil: \.autocapitalizationType) ?? .sentences
    }
    public var autocorrectionType: UITextAutocorrectionType {
        return modifiers.findLast(nonNil: \.autocorrectionType) ?? .default
    }
    public var returnKeyType: UIReturnKeyType {
        return modifiers.findLast(nonNil: \.returnKeyType) ?? .next
    }
    public var backgroundColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.backgroundColor)
    }
    public var tintColor: ColorGroup? {
        return modifiers.findLast(nonNil: \.tintColor)
    }
    public var cornerRound: CornerRound? {
        return modifiers.findLast(nonNil: \.cornerRound)
    }
    public var shadow: Shadow? {
        return modifiers.findLast(nonNil: \.shadow)
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
