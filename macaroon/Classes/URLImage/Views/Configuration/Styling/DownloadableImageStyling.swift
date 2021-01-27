// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol DownloadableImageStyleSheet: StyleSheet {
    var background: ViewStyle { get }
    var image: ImageStyle { get }
    var placeholder: DownloadableImagePlaceholderStyleSheet? { get }
}

extension DownloadableImageStyleSheet {
    public var background: ViewStyle {
        return []
    }

    public var image: ImageStyle {
        return .aspectFit()
    }

    public var placeholder: DownloadableImagePlaceholderStyleSheet? {
        return nil
    }
}
