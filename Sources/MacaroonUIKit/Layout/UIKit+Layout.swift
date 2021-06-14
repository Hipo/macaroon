// Copyright © Hipolabs. All rights reserved.

import Foundation
import UIKit

extension CGSize {
    public init(
        _ layoutSize: LayoutSize
    ) {
        self.init(width: layoutSize.w, height: layoutSize.h)
    }
}

extension UIEdgeInsets {
    public init(
        _ paddings: LayoutPaddings
    ) {
        self.init(
            top: paddings.top,
            left: paddings.leading,
            bottom: paddings.bottom,
            right: paddings.trailing
        )
    }
}

extension NSDirectionalEdgeInsets {
    public init(_ paddings: LayoutPaddings) {
        self.init(
            top: paddings.top,
            leading: paddings.leading,
            bottom: paddings.bottom,
            trailing: paddings.trailing
        )
    }
}
