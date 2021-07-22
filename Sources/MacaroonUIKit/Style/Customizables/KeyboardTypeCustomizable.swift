// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol KeyboardTypeCustomizable: UIView {
    var keyboardType: UIKeyboardType { get set }
}

extension UITextField: KeyboardTypeCustomizable {}

extension UITextView: KeyboardTypeCustomizable {}
