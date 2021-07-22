// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TextContentTypeCustomizable: UIView {
    var textContentType: UITextContentType! { get set }
}

extension UITextField: TextContentTypeCustomizable {}

extension UITextView: TextContentTypeCustomizable {}
