// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol DynamicTypeCustomizable: UIView {
    var adjustsFontForContentSizeCategory: Bool { get }
}

extension UILabel: DynamicTypeCustomizable {}

extension UITextField: DynamicTypeCustomizable {}

extension UITextView: DynamicTypeCustomizable {}
