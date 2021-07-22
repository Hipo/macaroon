// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Customizable where Self: UIPageControl {
    public func customizeAppearance(
        _ style: PageControlStyle
    ) {
        customizeBaseAppearance(indicatorColor: style.indicatorColor)
        customizeBaseAppearance(selectedIndicatorColor: style.selectedIndicatorColor)
        customizeBaseAppearance(indicatorImage: style.indicatorImage)
        customizeBaseAppearance(backgroundColor: style.backgroundColor)
        customizeBaseAppearance(tintColor: style.tintColor)
        customizeBaseAppearance(isInteractable: style.isInteractable)

        hidesForSinglePage = true
        isUserInteractionEnabled = false
    }

    public func recustomizeAppearance(
        _ style: PageControlStyle
    ) {
        resetAppearance()
        customizeAppearance(
            style
        )
    }

    public func resetAppearance() {
        resetBaseAppearance()

        customizeBaseAppearance(
            indicatorColor: nil
        )
        customizeBaseAppearance(
            selectedIndicatorColor: nil
        )
        customizeBaseAppearance(
            indicatorImage: nil
        )

        hidesForSinglePage = false
        isUserInteractionEnabled = true
    }
}

extension Customizable where Self: UIPageControl {
    public func customizeBaseAppearance(
        indicatorColor: Color?
    ) {
        pageIndicatorTintColor = indicatorColor?.uiColor
    }

    public func customizeBaseAppearance(
        selectedIndicatorColor: Color?
    ) {
        currentPageIndicatorTintColor = selectedIndicatorColor?.uiColor
    }

    public func customizeBaseAppearance(
        indicatorImage: Image?
    ) {
        if #available(iOS 14, *) {
            preferredIndicatorImage = indicatorImage?.uiImage
        }
    }
}
