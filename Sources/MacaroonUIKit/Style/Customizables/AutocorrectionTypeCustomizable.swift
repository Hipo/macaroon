// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol AutocorrectionTypeCustomizable: UIView {
    var autocorrectionType: UITextAutocorrectionType { get set }
}

extension UITextField: AutocorrectionTypeCustomizable {}

extension UITextView: AutocorrectionTypeCustomizable {}
