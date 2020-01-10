// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TabBarButtonItemConvertible {
    var style: ButtonStyling { get }
    var spacingBetweenImageAndTitle: CGFloat { get }
    var width: CGFloat { get } /// <note> The explicit width for the tabbar button
    var isSelectable: Bool { get }
}
