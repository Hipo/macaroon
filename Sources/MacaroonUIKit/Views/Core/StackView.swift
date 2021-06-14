// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class HStackView: UIStackView {
    public override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )

        axis = .horizontal
        alignment = .fill
        distribution = .fill
        spacing = 0
    }

    @available(*, unavailable)
    public required init(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class VStackView: UIStackView {
    public override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )

        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 0
    }

    @available(*, unavailable)
    public required init(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }
}
