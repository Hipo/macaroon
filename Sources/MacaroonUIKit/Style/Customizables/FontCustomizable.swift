// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol FontCustomizable: UIView {
    var someFont: Font? { get set }
}

extension UIButton: FontCustomizable {
    public var someFont: Font? {
        get { titleLabel?.font }
        set { titleLabel?.font = newValue?.uiFont }
    }
}

extension UILabel: FontCustomizable {
    public var someFont: Font? {
        get { font }
        set { font = newValue?.uiFont }
    }
}

extension UITextField: FontCustomizable {
    public var someFont: Font? {
        get { font }
        set { font = newValue?.uiFont }
    }
}

extension UITextView: FontCustomizable {
    public var someFont: Font? {
        get { font }
        set { font = newValue?.uiFont }
    }
}
