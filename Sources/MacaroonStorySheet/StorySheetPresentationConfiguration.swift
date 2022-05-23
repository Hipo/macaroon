// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonResources
import MacaroonUIKit

public struct StorySheetPresentationConfiguration: ModalPresentationConfiguration {
    public var chromeStyle: ViewStyle = [.backgroundColor(rgba(0, 0, 0, 0.2))]

    public var overlayStyleSheet = StorySheetOverlayViewStyleSheet()
    public var storySheetInset: LayoutMargins = (60, 24, 32, 24)
    public var contentMargin: LayoutVerticalMargins = (24, 24)
    
    public init() {}
}
