// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct ImagePlaceholder {
    public let source: AssetImageSource?
    public let description: EditText?

    public init(
        source: AssetImageSource? = nil,
        description: EditText? = nil
    ) {
        self.source = source
        self.description = description
    }
}
