// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public typealias TextInputStyle = BaseStyle<TextInputStyleAttribute>

extension TextInputStyle {
    public func mutate(
        by viewStyle: ViewStyle
    ) -> Self {
        var derivedTextInputStyle: TextInputStyle = []

        viewStyle.forEach {
            switch $0 {
            case .backgroundColor(let backgroundColor):
                derivedTextInputStyle.append(.backgroundColor(backgroundColor))
            case .tintColor(let tintColor):
                derivedTextInputStyle.append(.tintColor(tintColor))
            case .border(let border):
                derivedTextInputStyle.append(.border(border))
            case .corner(let corner):
                derivedTextInputStyle.append(.corner(corner))
            case .shadow(let shadow):
                derivedTextInputStyle.append(.shadow(shadow))
            }
        }

        return mutate(by: derivedTextInputStyle)
    }
}

public enum TextInputStyleAttribute: BaseStyleAttribute {
    /// <mark>
    /// Base
    case backgroundColor(Color)
    case tintColor(Color)
    case border(Border)
    case corner(Corner)
    case shadow(Shadow)

    /// <mark>
    /// TextInput
    case backgroundImage(Image)
    case font(Font)
    case textAlignment(NSTextAlignment)
    case textColor(Color)
    case content(Text)
    case placeholder(Text, Color? = nil)
    case clearButtonMode(UITextField.ViewMode)
    case keyboardType(UIKeyboardType)
    case returnKeyType(UIReturnKeyType)
    case autocapitalizationType(UITextAutocapitalizationType)
    case autocorrectionType(UITextAutocorrectionType)
}

extension TextInputStyleAttribute {
    public var id: String {
        switch self {
        case .backgroundColor: return Self.getBackgroundColorAttributeId()
        case .tintColor: return Self.getTintColorAttributeId()
        case .border: return Self.getBorderAttributeId()
        case .corner: return Self.getCornerAttributeId()
        case .shadow: return Self.getShadowAttributeId()
        case .backgroundImage: return "textInput.backgroundImage"
        case .font: return "textInput.font"
        case .textAlignment: return "textInput.textAlignment"
        case .textColor: return "textInput.textColor"
        case .content: return "textInput.content"
        case .placeholder: return "textInput.placeholder"
        case .clearButtonMode: return "textInput.clearButtonMode"
        case .keyboardType: return "textInput.keyboardType"
        case .returnKeyType: return "textInput.returnKeyType"
        case .autocapitalizationType: return "textInput.autocapitalizationType"
        case .autocorrectionType: return "textInput.autocorrectionType"
        }
    }
}
