// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

public protocol NavigationBarStyleAttribute: StyleAttribute where AnyView == UINavigationBar {}

public struct BackgroundColorNavigationBarStyleAttribute: NavigationBarStyleAttribute {
    public let color: Color

    public init(
        _ color: Color
    ) {
        self.color = color
    }

    public func apply(
        to view: UINavigationBar
    ) {
        let someColor = color.uiColor

        if #available(iOS 13, *) {
            view.applyToAppearance((\.backgroundColor, someColor))
        } else {
            view.barTintColor = someColor
        }
    }
}

public struct BackgroundImageNavigationBarStyleAttribute: NavigationBarStyleAttribute {
    public let image: Image

    public init(
        _ image: Image
    ) {
        self.image = image
    }

    public func apply(
        to view: UINavigationBar
    ) {
        let someImage = image.uiImage

        if #available(iOS 13, *) {
            view.applyToAppearance((\.backgroundImage, someImage))
        } else {
            view.setBackgroundImage(
                someImage,
                for: .default
            )
        }
    }
}

public struct BackImageNavigationBarStyleAttribute: NavigationBarStyleAttribute {
    public let image: Image

    public init(
        _ image: Image
    ) {
        self.image = image
    }

    public func apply(
        to view: UINavigationBar
    ) {
        let someImage = image.uiImage

        if #available(iOS 13, *) {
            view.standardAppearance.setBackIndicatorImage(
                someImage,
                transitionMaskImage: someImage
            )
            view.compactAppearance?.setBackIndicatorImage(
                someImage,
                transitionMaskImage: someImage
            )
            view.scrollEdgeAppearance?.setBackIndicatorImage(
                someImage,
                transitionMaskImage: someImage
            )
        } else {
            view.backIndicatorImage = someImage
            view.backIndicatorTransitionMaskImage = someImage
        }
    }
}

public struct LargeTitleNavigationBarStyleAttribute: NavigationBarStyleAttribute {
    public typealias Attribute = AttributedTextBuilder.Attribute

    public let attributes: [Attribute]

    public init(
        _ attributes: [Attribute]
    ) {
        self.attributes = attributes
    }

    public func apply(
        to view: UINavigationBar
    ) {
        let textAttributes = attributes.asSystemAttributes()

        if #available(iOS 13, *) {
            view.applyToAppearance((\.largeTitleTextAttributes, textAttributes))
        } else {
            view.largeTitleTextAttributes = textAttributes
        }
    }
}

public struct OpaqueNavigationBarStyleAttribute: NavigationBarStyleAttribute {
    public let isOpaque: Bool

    public init(
        _ opaque: Bool
    ) {
        self.isOpaque = opaque
    }

    public func apply(
        to view: UINavigationBar
    ) {
        view.isTranslucent = !isOpaque

        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()

            view.standardAppearance = appearance
            view.compactAppearance = appearance
            view.scrollEdgeAppearance = appearance
        }
    }
}

public struct ShadowColorNavigationBarStyleAttribute: NavigationBarStyleAttribute {
    public let color: Color

    public init(
        _ color: Color
    ) {
        self.color = color
    }

    public func apply(
        to view: UINavigationBar
    ) {
        if #available(iOS 13, *) {
            view.applyToAppearance((\.shadowColor, color.uiColor))
        }
    }
}

public struct ShadowImageNavigationBarStyleAttribute: NavigationBarStyleAttribute {
    public let image: Image

    public init(
        _ image: Image
    ) {
        self.image = image
    }

    public func apply(
        to view: UINavigationBar
    ) {
        let someImage = image.uiImage

        if #available(iOS 13, *) {
            view.applyToAppearance((\.shadowImage, someImage))
        } else {
            view.shadowImage = someImage
        }
    }
}

public struct TitleNavigationBarStyleAttribute: NavigationBarStyleAttribute {
    public typealias Attribute = AttributedTextBuilder.Attribute

    public let attributes: [Attribute]

    public init(
        _ attributes: [Attribute]
    ) {
        self.attributes = attributes
    }

    public func apply(
        to view: UINavigationBar
    ) {
        let textAttributes = attributes.asSystemAttributes()

        if #available(iOS 13, *) {
            view.applyToAppearance((\.titleTextAttributes, textAttributes))
        } else {
            view.titleTextAttributes = textAttributes
        }
    }
}

extension AnyStyleAttribute where AnyView == UINavigationBar {
    public static func backgroundColor(
        _ color: Color
    ) -> Self {
        return AnyStyleAttribute(
            BackgroundColorNavigationBarStyleAttribute(color)
        )
    }

    public static func backgroundImage(
        _ image: Image
    ) -> Self {
        return AnyStyleAttribute(
            BackgroundImageNavigationBarStyleAttribute(image)
        )
    }

    public static func isOpaque(
        _ opaque: Bool
    ) -> Self {
        return AnyStyleAttribute(
            OpaqueNavigationBarStyleAttribute(opaque)
        )
    }

    public static func largeTitle(
        _ attributes: [LargeTitleNavigationBarStyleAttribute.Attribute]
    ) -> Self {
        return AnyStyleAttribute(
            LargeTitleNavigationBarStyleAttribute(attributes)
        )
    }

    public static func shadowColor(
        _ color: Color
    ) -> Self {
        return AnyStyleAttribute(
            ShadowColorNavigationBarStyleAttribute(color)
        )
    }

    public static func shadowImage(
        _ image: Image
    ) -> Self {
        return AnyStyleAttribute(
            ShadowImageNavigationBarStyleAttribute(image)
        )
    }

    public static func title(
        _ attributes: [TitleNavigationBarStyleAttribute.Attribute]
    ) -> Self {
        return AnyStyleAttribute(
            TitleNavigationBarStyleAttribute(attributes)
        )
    }
}

@available(iOS 13, *)
extension UINavigationBar {
    public func applyToAppearance<T>(
        _ modifier: (ReferenceWritableKeyPath<UINavigationBarAppearance, T>, T)
    ) {
        applyToStandardAppearance(modifier)
        applyToCompactAppearance(modifier)
        applyToScrollEdgeAppearance(modifier)
    }

    public func applyToStandardAppearance<T>(
        _ modifier: (ReferenceWritableKeyPath<UINavigationBarAppearance, T>, T)
    ) {
        let mAppearance = standardAppearance
        mAppearance[keyPath: modifier.0] = modifier.1
        standardAppearance = mAppearance
    }

    public func applyToCompactAppearance<T>(
        _ modifier: (ReferenceWritableKeyPath<UINavigationBarAppearance, T>, T)
    ) {
        let mAppearance = compactAppearance
        mAppearance?[keyPath: modifier.0] = modifier.1
        compactAppearance = mAppearance
    }

    public func applyToScrollEdgeAppearance<T>(
        _ modifier: (ReferenceWritableKeyPath<UINavigationBarAppearance, T>, T)
    ) {
        let mAppearance = scrollEdgeAppearance
        mAppearance?[keyPath: modifier.0] = modifier.1
        scrollEdgeAppearance = mAppearance
    }
}
