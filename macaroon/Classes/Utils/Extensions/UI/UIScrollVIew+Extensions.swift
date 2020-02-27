// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UIScrollView {
    public func scrollToBottom(force: Bool = false, animated: Bool = true) {
        let height = bounds.height
        let contentHeight = contentSize.height + adjustedContentInset.bottom

        if force || height < contentHeight {
            setContentOffset(CGPoint(x: contentOffset.x, y: contentHeight - height), animated: animated)
        }
    }
}
