// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TextAlignmentCustomizable: UIView {
    var textAlignment: NSTextAlignment { get set }
}

extension UILabel: TextAlignmentCustomizable {}

extension UITextField: TextAlignmentCustomizable {}

extension UITextView: TextAlignmentCustomizable {}
