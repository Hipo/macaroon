// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct ImagePlaceholder {
    public let image: UIImage?
    public let title: EditText?

    public init(
        image: UIImage? = nil,
        title: EditText? = nil
    ) {
        self.image = image
        self.title = title
    }
}
