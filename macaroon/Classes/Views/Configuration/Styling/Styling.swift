// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Styling {
    var backgroundColor: ColorGroup? { get }
    var tintColor: ColorGroup? { get }
    var cornerRound: CornerRound? { get }
    var shadow: Shadow? { get }
}

extension Styling {
    public var backgroundColor: ColorGroup? {
        return nil
    }
    public var tintColor: ColorGroup? {
        return nil
    }
    public var cornerRound: CornerRound? {
        return nil
    }
    public var shadow: Shadow? {
        return nil
    }
}

public protocol ButtonStyling: Styling {
    var background: ImageGroup? { get }
    var icon: ImageGroup? { get }
    var font: FontGroup? { get }
    var textColor: ColorGroup? { get }
    var title: TextGroup? { get }
}

extension ButtonStyling {
    public var background: ImageGroup? {
        return nil
    }
    public var icon: ImageGroup? {
        return nil
    }
    public var font: FontGroup? {
        return nil
    }
    public var textColor: ColorGroup? {
        return nil
    }
    public var title: TextGroup? {
        return nil
    }
}

public protocol ImageStyling: Styling {
    var image: UIImage? { get }
    var contentMode: UIView.ContentMode { get }
}

extension ImageStyling {
    public var image: UIImage? {
        return nil
    }
    public var contentMode: UIView.ContentMode {
        return .scaleToFill
    }
}

public protocol TextStyling: Styling {
    var font: FontGroup? { get }
    var textColor: ColorGroup? { get }
    var textAlignment: NSTextAlignment { get }
    var textOverflow: TextOverflow { get }
    var text: TextGroup? { get }
}

extension TextStyling {
    public var font: FontGroup? {
        return nil
    }
    public var textColor: ColorGroup? {
        return nil
    }
    public var textAlignment: NSTextAlignment {
        return .left
    }
    public var textOverflow: TextOverflow {
        return .truncated
    }
    public var text: TextGroup? {
        return nil
    }
}

public protocol TextInputStyling: Styling {
    var background: ImageGroup? { get }
    var font: FontGroup? { get }
    var textColor: ColorGroup? { get }
    var textAlignment: NSTextAlignment { get }
    var placeholderColor: ColorGroup? { get }
    var placeholderText: EditText? { get }
    var clearButtonMode: UITextField.ViewMode { get }
    var keyboardType: UIKeyboardType { get }
    var autocapitalizationType: UITextAutocapitalizationType { get }
    var autocorrectionType: UITextAutocorrectionType { get }
    var returnKeyType: UIReturnKeyType { get }
}

extension TextInputStyling {
    public var background: ImageGroup? {
        return nil
    }
    public var font: FontGroup? {
        return nil
    }
    public var textColor: ColorGroup? {
        return nil
    }
    public var textAlignment: NSTextAlignment {
        return .left
    }
    public var placeholderColor: ColorGroup? {
        return nil
    }
    public var placeholderText: EditText? {
        return nil
    }
    public var clearButtonMode: UITextField.ViewMode {
        return .whileEditing
    }
    public var keyboardType: UIKeyboardType {
        return .default
    }
    public var autocapitalizationType: UITextAutocapitalizationType {
        return .sentences
    }
    public var autocorrectionType: UITextAutocorrectionType {
        return .default
    }
    public var returnKeyType: UIReturnKeyType {
        return .next
    }
}

public struct NoStyle: Styling {
    public init() { }
}

public struct NoButtonStyle: ButtonStyling {
    public init() { }
}

public struct NoImageStyle: ImageStyling {
    public init() { }
}

public struct NoTextStyle: TextStyling {
    public init() { }
}

public struct NoTextInputStyle: TextInputStyling {
    public init() { }
}
