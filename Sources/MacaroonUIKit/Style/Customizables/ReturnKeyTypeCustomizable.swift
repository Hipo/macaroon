// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ReturnKeyTypeCustomizable: UIView {
    var returnKeyType: UIReturnKeyType { get set }
}

extension UITextField: ReturnKeyTypeCustomizable {}

extension UITextView: ReturnKeyTypeCustomizable {}
