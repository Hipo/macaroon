// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol DownloadableImagePlaceholderStyleSheet: StyleSheet {
    var background: ViewStyle { get }
    var image: ImageStyle { get }
    var text: TextStyle { get }
}

extension DownloadableImagePlaceholderStyleSheet {
    public var background: ViewStyle {
        return []
    }

    public var image: ImageStyle {
        return .aspectFit()
    }

    public var text: TextStyle {
        return []
    }
}
