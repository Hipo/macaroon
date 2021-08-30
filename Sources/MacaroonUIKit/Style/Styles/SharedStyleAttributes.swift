// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

public struct BackgroundColorStyleAttribute<
    AnyView: UIView
>: StyleAttribute {
    public let color: Color

    public init(
        _ color: Color
    ) {
        self.color = color
    }

    public func apply(
        to view: AnyView
    ) {
        view.backgroundColor = color.uiColor
    }
}

public struct TintColorStyleAttribute<
    AnyView: UIView
>: StyleAttribute {
    public let color: Color

    public init(
        _ color: Color
    ) {
        self.color = color
    }

    public func apply(
        to view: AnyView
    ) {
        view.tintColor = color.uiColor
    }
}

public struct FontStyleAttribute<
    AnyView: FontCustomizable
>: StyleAttribute {
    public let font: Font

    public init(
        _ font: Font
    ) {
        self.font = font
    }

    public func apply(
        to view: AnyView
    ) {
        view.mc_font = font
    }
}

public struct TextAlignmentStyleAttribute<
    AnyView: TextAlignmentCustomizable
>: StyleAttribute {
    public let alignment: NSTextAlignment

    public init(
        _ alignment: NSTextAlignment
    ) {
        self.alignment = alignment
    }

    public func apply(
        to view: AnyView
    ) {
        view.textAlignment = alignment
    }
}

public struct TextColorStyleAttribute<
    AnyView: TextColorCustomizable
>: StyleAttribute {
    public let color: Color

    public init(
        _ color: Color
    ) {
        self.color = color
    }

    public func apply(
        to view: AnyView
    ) {
        view.mc_textColor = color
    }
}

extension AnyStyleAttribute {
    public static func backgroundColor(
        _ color: Color
    ) -> Self {
        return AnyStyleAttribute(
            BackgroundColorStyleAttribute<AnyView>(color)
        )
    }

    public static func tintColor(
        _ color: Color
    ) -> Self {
        return AnyStyleAttribute(
            TintColorStyleAttribute<AnyView>(color)
        )
    }
}

extension AnyStyleAttribute where AnyView: FontCustomizable {
    public static func font(
        _ font: Font
    ) -> Self {
        return AnyStyleAttribute(
            FontStyleAttribute<AnyView>(font)
        )
    }
}

extension AnyStyleAttribute where AnyView: TextAlignmentCustomizable {
    public static func textAlignment(
        _ alignment: NSTextAlignment
    ) -> Self {
        return AnyStyleAttribute(
            TextAlignmentStyleAttribute(alignment)
        )
    }
}

extension AnyStyleAttribute where AnyView: TextColorCustomizable {
    public static func textColor(
        _ color: Color
    ) -> Self {
        return AnyStyleAttribute(
            TextColorStyleAttribute(color)
        )
    }
}
