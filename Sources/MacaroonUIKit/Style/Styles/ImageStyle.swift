// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public typealias ImageStyle = BaseStyle<ImageStyleAttribute>

extension ImageStyle {
    public var tintColor: Color? {
        for attribute in self {
            switch attribute {
            case .tintColor(let tintColor): return tintColor
            default: break
            }
        }

        return nil
    }

    public var content: Image? {
        for attribute in self {
            switch attribute {
            case .content(let content): return content
            default: break
            }
        }

        return nil
    }
}

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
            case .isInteractable(let isInteractable):
                derivedImageStyle.append(.isInteractable(isInteractable))
            }
        }

        return mutate(by: derivedImageStyle)
    }
}

extension ImageStyle {
    public static func scaleToFill(
        content: Image? = nil
    ) -> ImageStyle {
        var style = ImageStyle()
        style.append(.contentMode(.scaleToFill))

        if let content = content {
            style.append(.content(content))
        }

        return style
    }

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
    case isInteractable(Bool)

    /// <mark>
    /// Image
    case contentMode(UIView.ContentMode)
    case adjustsImageForContentSizeCategory(Bool)
    case content(Image)
}

extension ImageStyleAttribute {
    public var id: String {
        switch self {
        case .backgroundColor: return Self.getBackgroundColorAttributeId()
        case .tintColor: return Self.getTintColorAttributeId()
        case .isInteractable: return Self.getIsInteractableAttributeId()
        case .contentMode: return "image.contentMode"
        case .adjustsImageForContentSizeCategory: return "image.adjustsImageForContentSizeCategory"
        case .content: return "image.image"
        }
    }
}
