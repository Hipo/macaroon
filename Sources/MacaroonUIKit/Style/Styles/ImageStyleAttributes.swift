// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

public protocol ImageStyleAttribute: StyleAttribute where AnyView == UIImageView {}

public struct ContentImageStyleAttribute: ImageStyleAttribute {
    public let image: Image

    public init(
        _ image: Image
    ) {
        self.image = image
    }

    public func apply(
        to view: UIImageView
    ) {
        view.image = image.uiImage
    }
}

public struct ContentModeImageStyleAttribute: ImageStyleAttribute {
    public let contentMode: UIView.ContentMode

    public init(
        _ contentMode: UIView.ContentMode
    ) {
        self.contentMode = contentMode
    }

    public func apply(
        to view: UIImageView
    ) {
        view.contentMode = contentMode
    }
}

public struct DynamicTypeImageStyleAttribute: ImageStyleAttribute {
    public let isSupported: Bool

    public init(
        _ supported: Bool
    ) {
        self.isSupported = supported
    }

    public func apply(
        to view: UIImageView
    ) {
        view.adjustsImageSizeForAccessibilityContentSizeCategory = isSupported
    }
}

extension AnyStyleAttribute where AnyView == UIImageView {
    public static func content(
        _ image: Image
    ) -> Self {
        return AnyStyleAttribute(
            ContentImageStyleAttribute(image)
        )
    }

    public static func contentMode(
        _ contentMode: UIView.ContentMode
    ) -> Self {
        return AnyStyleAttribute(
            ContentModeImageStyleAttribute(contentMode)
        )
    }

    public static func supportsDynamicType(
        _ supported: Bool
    ) -> Self {
        return AnyStyleAttribute(
            DynamicTypeImageStyleAttribute(supported)
        )
    }
}
