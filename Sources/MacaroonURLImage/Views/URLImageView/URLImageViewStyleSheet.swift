// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public protocol URLImageViewStyleSheet: StyleSheet {
    var background: ViewStyle { get }
    var content: ImageStyle { get }
    var placeholderStyleSheet: URLImagePlaceholderViewStyleSheet? { get }
}
