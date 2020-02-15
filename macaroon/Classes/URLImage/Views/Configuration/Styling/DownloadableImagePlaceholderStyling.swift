// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol DownloadableImagePlaceholderStyling: Styling {
    var contentMode: UIView.ContentMode { get }
    var font: FontGroup? { get }
    var textColor: ColorGroup? { get }
    var textAlignment: NSTextAlignment { get }
    var textOverflow: TextOverflow { get }
}

extension DownloadableImagePlaceholderStyling {
    public var contentMode: UIView.ContentMode {
        return .scaleToFill
    }
    public var font: FontGroup? {
        return nil
    }
    public var titleColor: ColorGroup? {
        return nil
    }
    public var textAlignment: NSTextAlignment {
        return .left
    }
    public var textOverflow: TextOverflow {
        return .truncated
    }
}
