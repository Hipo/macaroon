// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct ImagePlaceholder {
    public let source: AssetImageSource?
    public let title: EditText?

    public init(
        source: AssetImageSource? = nil,
        title: EditText? = nil
    ) {
        self.source = source
        self.title = title
    }
}
