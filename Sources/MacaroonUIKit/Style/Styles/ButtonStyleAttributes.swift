// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

public protocol ButtonStyleAttribute: StyleAttribute where AnyView == UIButton {}

public struct BackgroundImageButtonStyleAttribute: ButtonStyleAttribute {
    public let imageGroup: ImageGroup

    public init(
        _ imageGroup: ImageGroup
    ) {
        self.imageGroup = imageGroup
    }

    public func apply(
        to view: UIButton
    ) {
        imageGroup.forEach {
            view.setBackgroundImage(
                $0.uiImage,
                for: $0.state
            )

            if $0.state == .selected {
                view.setBackgroundImage(
                    $0.uiImage,
                    for: [.selected, .highlighted]
                )
            }
        }
    }
}

public struct IconButtonStyleAttribute: ButtonStyleAttribute {
    public let imageGroup: ImageGroup

    public init(
        _ imageGroup: ImageGroup
    ) {
        self.imageGroup = imageGroup
    }

    public func apply(
        to view: UIButton
    ) {
        imageGroup.forEach {
            view.setImage(
                $0.uiImage,
                for: $0.state
            )

            if $0.state == .selected {
                view.setImage(
                    $0.uiImage,
                    for: [.selected, .highlighted]
                )
            }
        }
    }
}

public struct TitleColorButtonStyleAttribute: ButtonStyleAttribute {
    public let colorGroup: ColorGroup

    public init(
        _ colorGroup: ColorGroup
    ) {
        self.colorGroup = colorGroup
    }

    public func apply(
        to view: UIButton
    ) {
        colorGroup.forEach {
            view.setTitleColor(
                $0.uiColor,
                for: $0.state
            )

            if $0.state == .selected {
                view.setTitleColor(
                    $0.uiColor,
                    for: [.selected, .highlighted]
                )
            }
        }
    }
}

extension AnyStyleAttribute where AnyView == UIButton {
    public static func backgroundImage(
        _ imageGroup: ImageGroup
    ) -> Self {
        return AnyStyleAttribute(
            BackgroundImageButtonStyleAttribute(imageGroup)
        )
    }

    public static func icon(
        _ imageGroup: ImageGroup
    ) -> Self {
        return AnyStyleAttribute(
            IconButtonStyleAttribute(imageGroup)
        )
    }

    public static func titleColor(
        _ colorGroup: ColorGroup
    ) -> Self {
        return AnyStyleAttribute(
            TitleColorButtonStyleAttribute(colorGroup)
        )
    }
}
