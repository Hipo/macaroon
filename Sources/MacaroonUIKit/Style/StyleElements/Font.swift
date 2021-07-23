// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Font {
    var uiFont: UIFont { get }
}

extension UIFont: Font {
    public var uiFont: UIFont {
        return self
    }
}

extension UIFont {
    public static func logAll() {
        UIFont.familyNames.forEach {
            family in

            UIFont.fontNames(forFamilyName: family).forEach {
                font in

                print(font)
            }
        }
    }
}

public protocol FontSize {
    var preferredFontSize: CGFloat { get }
    var maxFontSize: CGFloat? { get }
}

extension FontSize {
    public static func clamped(
        preferred: CGFloat,
        max: CGFloat
    ) -> ClampedFontSize {
        return ClampedFontSize(preferred: preferred, max: max)
    }
}

extension CGFloat: FontSize {
    public var preferredFontSize: CGFloat {
        return self
    }
    public var maxFontSize: CGFloat? {
        return nil
    }
}

extension Double: FontSize {
    public var preferredFontSize: CGFloat {
        return cgFloat
    }
    public var maxFontSize: CGFloat? {
        return nil
    }
}

extension Int: FontSize {
    public var preferredFontSize: CGFloat {
        return cgFloat
    }
    public var maxFontSize: CGFloat? {
        return nil
    }
}

public struct ClampedFontSize: FontSize {
    public let preferredFontSize: CGFloat
    public let maxFontSize: CGFloat?

    public init(
        preferred: CGFloat,
        max: CGFloat
    ) {
        self.preferredFontSize = preferred
        self.maxFontSize = max
    }
}

public struct CustomFont: Font {
    public typealias Style = UIFont.TextStyle

    public let uiFont: UIFont

    public init(
        name: String,
        size: FontSize,
        style: Style? = nil
    ) {
        let font =
            UIFont(name: name, size: size.preferredFontSize) ??
            UIFont.systemFont(ofSize: size.preferredFontSize)

        guard let style = style else {
            self.uiFont = font
            return
        }

        let metrics = UIFontMetrics(forTextStyle: style)

        guard let maxFontSize = size.maxFontSize else {
            self.uiFont = metrics.scaledFont(for: font)
            return
        }

        self.uiFont =
            metrics.scaledFont(
                for: font,
                maximumPointSize: maxFontSize
            )
    }
}
