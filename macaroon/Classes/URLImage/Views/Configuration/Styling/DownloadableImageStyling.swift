// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol DownloadableImageStyling: ImageStyling {
    var placeholder: DownloadableImagePlaceholderStyling? { get }
}

extension DownloadableImageStyling {
    public var placeholder: DownloadableImagePlaceholderStyling? {
        return nil
    }
}
