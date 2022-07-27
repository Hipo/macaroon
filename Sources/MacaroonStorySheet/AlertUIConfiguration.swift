// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonResources
import MacaroonUIKit
import UIKit

public struct AlertUIConfiguration: ModalPresentationConfiguration {
    public var chromeStyle: ViewStyle

    public var contentAreaCorner: Corner
    public var contentAreaPrimaryShadow: Shadow?
    public var contentAreaSecondaryShadow: Shadow?
    public var contentAreaInsets: UIEdgeInsets
    
    public init() {
        self.chromeStyle = [
            .backgroundColor(rgba(0, 0, 0, 0.2))
        ]

        self.contentAreaCorner = 0
        self.contentAreaInsets = .zero
    }
}
