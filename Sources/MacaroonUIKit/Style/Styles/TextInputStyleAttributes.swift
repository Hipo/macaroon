// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

public protocol TextFieldStyleAttribute: StyleAttribute where AnyView == UITextField {}

public struct AutocapitalizationTypeTextInputStyleAttribute<
    AnyView: AutocapitalizationTypeCustomizable
>: StyleAttribute {
    public let type: UITextAutocapitalizationType

    public init(
        _ type: UITextAutocapitalizationType
    ) {
        self.type = type
    }

    public func apply(
        to view: AnyView
    ) {
        view.autocapitalizationType = type
    }
}

public struct AutocorrectionTypeTextInputStyleAttribute<
    AnyView: AutocorrectionTypeCustomizable
>: StyleAttribute {
    public let type: UITextAutocorrectionType

    public init(
        _ type: UITextAutocorrectionType
    ) {
        self.type = type
    }

    public func apply(
        to view: AnyView
    ) {
        view.autocorrectionType = type
    }
}

public struct BackgroundImageTextInputStyleAttribute: TextFieldStyleAttribute {
    public let image: Image
    public let disabledImage: Image?

    public init(
        _ image: Image,
        disabledImage: Image? = nil
    ) {
        self.image = image
        self.disabledImage = disabledImage
    }

    public func apply(
        to view: UITextField
    ) {
        view.background = image.uiImage
        view.disabledBackground = disabledImage?.uiImage
    }
}

public struct ClearButtonModeTextInputStyleAttribute: TextFieldStyleAttribute {
    public typealias Mode = UITextField.ViewMode

    public let mode: Mode

    public init(
        _ mode: Mode
    ) {
        self.mode = mode
    }

    public func apply(
        to view: UITextField
    ) {
        view.clearButtonMode = mode
    }
}

public struct ContentTypeTextInputStyleAttribute<
    AnyView: TextContentTypeCustomizable
>: StyleAttribute {
    public let type: UITextContentType

    public init(
        _ type: UITextContentType
    ) {
        self.type = type
    }

    public func apply(
        to view: AnyView
    ) {
        view.textContentType = type
    }
}

public struct KeyboardTypeTextInputStyleAttribute<
    AnyView: KeyboardTypeCustomizable
>: StyleAttribute {
    public let type: UIKeyboardType

    public init(
        _ type: UIKeyboardType
    ) {
        self.type = type
    }

    public func apply(
        to view: AnyView
    ) {
        view.keyboardType = type
    }
}

public struct ReturnKeyTypeTextInputStyleAttribute<
    AnyView: ReturnKeyTypeCustomizable
>: StyleAttribute {
    public let type: UIReturnKeyType

    public init(
        _ type: UIReturnKeyType
    ) {
        self.type = type
    }

    public func apply(
        to view: AnyView
    ) {
        view.returnKeyType = type
    }
}

public struct SecureTextInputStyleAttribute: TextFieldStyleAttribute {
    public let isSecure: Bool

    public init(
        _ secure: Bool
    ) {
        self.isSecure = secure
    }

    public func apply(
        to view: UITextField
    ) {
        view.isSecureTextEntry = isSecure
    }
}

extension AnyStyleAttribute where AnyView == UITextField {
    public static func backgroundImage(
        _ image: Image,
        disabledImage: Image? = nil
    ) -> Self {
        return AnyStyleAttribute(
            BackgroundImageTextInputStyleAttribute(image, disabledImage: disabledImage)
        )
    }

    public static func clearButtonMode(
        _ mode: ClearButtonModeTextInputStyleAttribute.Mode
    ) -> Self {
        return AnyStyleAttribute(
            ClearButtonModeTextInputStyleAttribute(mode)
        )
    }

    public static func secure(
        _ secure: Bool
    ) -> Self {
        return AnyStyleAttribute(
            SecureTextInputStyleAttribute(secure)
        )
    }
}

extension AnyStyleAttribute where AnyView: AutocapitalizationTypeCustomizable {
    public static func autocapitalizationType(
        _ type: UITextAutocapitalizationType
    ) -> Self {
        return AnyStyleAttribute(
            AutocapitalizationTypeTextInputStyleAttribute(type)
        )
    }
}

extension AnyStyleAttribute where AnyView: AutocorrectionTypeCustomizable {
    public static func autocorrectionType(
        _ type: UITextAutocorrectionType
    ) -> Self {
        return AnyStyleAttribute(
            AutocorrectionTypeTextInputStyleAttribute(type)
        )
    }
}

extension AnyStyleAttribute where AnyView: TextContentTypeCustomizable {
    public static func contentType(
        _ type: UITextContentType
    ) -> Self {
        return AnyStyleAttribute(
            ContentTypeTextInputStyleAttribute(type)
        )
    }
}

extension AnyStyleAttribute where AnyView: KeyboardTypeCustomizable {
    public static func keyboardType(
        _ type: UIKeyboardType
    ) -> Self {
        return AnyStyleAttribute(
            KeyboardTypeTextInputStyleAttribute(type)
        )
    }
}

extension AnyStyleAttribute where AnyView: ReturnKeyTypeCustomizable {
    public static func returnKeyType(
        _ type: UIReturnKeyType
    ) -> Self {
        return AnyStyleAttribute(
            ReturnKeyTypeTextInputStyleAttribute(type)
        )
    }
}
