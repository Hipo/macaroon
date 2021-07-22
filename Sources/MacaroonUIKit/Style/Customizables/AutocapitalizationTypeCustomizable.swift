// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol AutocapitalizationTypeCustomizable: UIView {
    var autocapitalizationType: UITextAutocapitalizationType { get set }
}

extension UITextField: AutocapitalizationTypeCustomizable {}

extension UITextView: AutocapitalizationTypeCustomizable {}
