// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TextColorCustomizable: UIView {
    var mc_textColor: Color? { get set }
}

extension UILabel: TextColorCustomizable {
    public var mc_textColor: Color? {
        get { textColor }
        set { textColor = newValue?.uiColor }
    }
}

extension UITextField: TextColorCustomizable {
    public var mc_textColor: Color? {
        get { textColor }
        set { textColor = newValue?.uiColor }
    }
}

extension UITextView: TextColorCustomizable {
    public var mc_textColor: Color? {
        get { textColor }
        set { textColor = newValue?.uiColor }
    }
}
