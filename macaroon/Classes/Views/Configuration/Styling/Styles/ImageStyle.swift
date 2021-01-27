// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public typealias ImageStyle = BaseStyle<ImageStyleAttribute>

extension ImageStyle {
    public func mutate(
        by viewStyle: ViewStyle
    ) -> Self {
        var derivedImageStyle: ImageStyle = []

        viewStyle.forEach {
            switch $0 {
            case .backgroundColor(let backgroundColor):
                derivedImageStyle.append(.backgroundColor(backgroundColor))
            case .tintColor(let tintColor):
                derivedImageStyle.append(.tintColor(tintColor))
            case .border(let border):
                derivedImageStyle.append(.border(border))
            case .corner(let corner):
                derivedImageStyle.append(.corner(corner))
            case .shadow(let shadow):
                derivedImageStyle.append(.shadow(shadow))
            }
        }

        return mutate(by: derivedImageStyle)
    }
}

extension ImageStyle {
    public static func aspectFit(
        _ content: Image? = nil
    ) -> ImageStyle {
        var style = ImageStyle()
        style.append(.contentMode(.scaleAspectFit))

        if let content = content {
            style.append(.content(content))
        }

        return style
    }

    public static func aspectFill(
        _ content: Image? = nil
    ) -> ImageStyle {
        var style = ImageStyle()
        style.append(.contentMode(.scaleAspectFill))

        if let content = content {
            style.append(.content(content))
        }

        return style
    }
}

public enum ImageStyleAttribute: BaseStyleAttribute {
    /// <mark>
    /// Base
    case backgroundColor(Color)
    case tintColor(Color)
    case border(Border)
    case corner(Corner)
    case shadow(Shadow)

    /// <mark>
    /// Image
    case contentMode(UIView.ContentMode)
    case content(Image)
}

extension ImageStyleAttribute {
    public var id: String {
        switch self {
        case .backgroundColor: return Self.getBackgroundColorAttributeId()
        case .tintColor: return Self.getTintColorAttributeId()
        case .border: return Self.getBorderAttributeId()
        case .corner: return Self.getCornerAttributeId()
        case .shadow: return Self.getShadowAttributeId()
        case .contentMode: return "image.contentMode"
        case .content: return "image.content"
        }
    }
}
