// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

public protocol PageControlStyleAttribute: StyleAttribute where AnyView == UIPageControl {}

public struct IndicatorColorPageControlStyleAttribute: PageControlStyleAttribute {
    public let color: Color

    public init(
        _ color: Color
    ) {
        self.color = color
    }

    public func apply(
        to view: UIPageControl
    ) {
        view.pageIndicatorTintColor = color.uiColor
    }
}

@available(iOS 14, *)
public struct IndicatorImagePageControlStyleAttribute: PageControlStyleAttribute {
    public let image: Image
    public let page: Int?

    public init(
        _ image: Image,
        at page: Int? = nil
    ) {
        self.image = image
        self.page = page
    }

    public func apply(
        to view: UIPageControl
    ) {
        let someImage = image.uiImage

        if let page = page {
            view.setIndicatorImage(
                someImage,
                forPage: page
            )
        } else {
            view.preferredIndicatorImage = someImage
        }
    }
}

public struct SelectedIndicatorColorPageControlStyleAttribute: PageControlStyleAttribute {
    public let color: Color

    public init(
        _ color: Color
    ) {
        self.color = color
    }

    public func apply(
        to view: UIPageControl
    ) {
        view.currentPageIndicatorTintColor = color.uiColor
    }
}

extension AnyStyleAttribute where AnyView == UIPageControl {
    public static func indicatorColor(
        _ color: Color
    ) -> Self {
        return AnyStyleAttribute(
            IndicatorColorPageControlStyleAttribute(color)
        )
    }

    @available(iOS 14, *)
    public static func indicatorImage(
        _ image: Image,
        at page: Int? = nil
    ) -> Self {
        return AnyStyleAttribute(
            IndicatorImagePageControlStyleAttribute(
                image,
                at: page
            )
        )
    }

    public static func selectedIndicatorColor(
        _ color: Color
    ) -> Self {
        return AnyStyleAttribute(
            SelectedIndicatorColorPageControlStyleAttribute(color)
        )
    }
}
