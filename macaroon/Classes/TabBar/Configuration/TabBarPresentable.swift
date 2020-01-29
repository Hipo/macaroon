// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TabBarPresentable: UIView {
    var barButtonItems: [TabBarButtonItemConvertible] { get set }
    var selectedBarButtonIndex: Int? { get set }
    var barButtonDidSelect: ((Int) -> Void)? { get set }
}
