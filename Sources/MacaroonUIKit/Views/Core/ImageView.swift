// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ImageView: UIImageView {
    open override var intrinsicContentSize: CGSize {
        if image == nil {
            return .zero
        }
        
        var implicitContentSize = super.intrinsicContentSize
        implicitContentSize.width += contentEdgeInsets.x
        implicitContentSize.height += contentEdgeInsets.y
        return implicitContentSize
    }
    
    /// <note>
    /// The custom values will affect the `intrinsicContentSize`, the content will be positioned
    /// by `contentMode`.
    public var contentEdgeInsets: LayoutOffset = (0, 0)
}
