// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import SnapKit
import UIKit

open class StorySheetOverlayView:
    View,
    DoubleShadowDrawable {
    public var secondShadow: Shadow?

    public private(set) lazy var secondShadowLayer = CAShapeLayer()

    open func customizeAppearance(
        _ styleSheet: StorySheetOverlayViewStyleSheet
    ) {
        customizeAppearance(
            styleSheet.background
        )

        drawAppearance(
            shadow: styleSheet.backgroundShadow
        )
        drawAppearance(
            secondShadow: styleSheet.backgroundSecondShadow
        )
    }
    
    open func prepareLayout(
        _ layoutSheet: NoLayoutSheet
    ) {
    }

    open func resetShadowAppearance() {
        eraseShadow()
        eraseSecondShadow()
    }

    open override func preferredUserInterfaceStyleDidChange() {
        super.preferredUserInterfaceStyleDidChange()

        drawAppearance(
            secondShadow: secondShadow
        )
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let secondShadow = secondShadow else {
            return
        }

        updateOnLayoutSubviews(
            secondShadow: secondShadow
        )
    }
}

public struct StorySheetOverlayViewStyleSheet: StyleSheet {
    public var background: ViewStyle
    public var backgroundShadow: Shadow?
    public var backgroundSecondShadow: Shadow?

    public init() {
        self.background = []
        self.backgroundShadow = nil
        self.backgroundSecondShadow = nil
    }
}
