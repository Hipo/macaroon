// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TextCustomizable: UIView {
    var mc_text: String? { get set }
    var mc_attributedText: NSAttributedString? { get set }
}

public protocol StateTextCustomizable: UIView {
    typealias State = UIControl.State

    func mc_setText(_ text: String?, for state: State)
    func mc_setAttributedText(_ attributedText: NSAttributedString?, for state: State)
}

extension UIButton: TextCustomizable {
    public var mc_text: String? {
        get { title(for: .normal) }
        set {
            setTitle(
                newValue,
                for: .normal
            )
        }
    }
    public var mc_attributedText: NSAttributedString? {
        get { attributedTitle(for: .normal) }
        set {
            setAttributedTitle(
                newValue,
                for: .normal
            )
        }
    }
}

extension UIButton: StateTextCustomizable {
    public func mc_setText(
        _ text: String?,
        for state: State
    ) {
        setTitle(
            text,
            for: state
        )
    }

    public func mc_setAttributedText(
        _ attributedText: NSAttributedString?,
        for state: State
    ) {
        setAttributedTitle(
            attributedText,
            for: state
        )
    }
}

extension UILabel: TextCustomizable {
    public var mc_text: String? {
        get { text }
        set { text = newValue }
    }
    public var mc_attributedText: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
}

extension UITextField: TextCustomizable {
    public var mc_text: String? {
        get { text }
        set { text = newValue }
    }
    public var mc_attributedText: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
}

extension UITextView: TextCustomizable {
    public var mc_text: String? {
        get { text }
        set { text = newValue }
    }
    public var mc_attributedText: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
}
