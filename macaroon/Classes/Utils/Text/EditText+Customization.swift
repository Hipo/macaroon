// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UILabel {
    public var editText: EditText? {
        get {
            if let attributedText = attributedText {
                return .attributed(attributedText)
            }
            if let text = text {
                return .normal(text)
            }
            return nil
        }
        set {
            guard let newEditText = newValue else {
                attributedText = nil
                text = nil
                return
            }
            switch newEditText {
            case .normal(let someText, _):
                attributedText = nil
                text = someText
            case .attributed(let someAttributedText):
                text = nil
                attributedText = someAttributedText
            }
        }
    }
}

extension UITextField {
    public var editText: EditText? {
        get {
            if let attributedText = attributedText {
                return .attributed(attributedText)
            }
            if let text = text {
                return .normal(text)
            }
            return nil
        }
        set {
            guard let newEditText = newValue else {
                attributedText = nil
                text = nil
                return
            }
            switch newEditText {
            case .normal(let someText, _):
                attributedText = nil
                text = someText
            case .attributed(let someAttributedText):
                text = nil
                attributedText = someAttributedText
            }
        }
    }
}

extension UITextView {
    public var editText: EditText? {
        get {
            if let attributedText = attributedText {
                return .attributed(attributedText)
            }
            if let text = text {
                return .normal(text)
            }
            return nil
        }
        set {
            guard let newEditText = newValue else {
                attributedText = nil
                text = nil
                return
            }
            switch newEditText {
            case .normal(let someText, _):
                attributedText = nil
                text = someText
            case .attributed(let someAttributedText):
                text = nil
                attributedText = someAttributedText
            }
        }
    }
}

extension UIButton {
    public var editTitle: EditText? {
        get {
            if let attributedText = currentAttributedTitle {
                return .attributed(attributedText)
            }
            if let text = currentTitle {
                return .normal(text)
            }
            return nil
        }
        set {
            guard let newEditText = newValue else {
                setAttributedTitle(nil, for: state)
                setTitle(nil, for: state)
                return
            }
            switch newEditText {
            case .normal(let title, _):
                setAttributedTitle(nil, for: state)
                setTitle(title, for: state)
            case .attributed(let attributedTitle):
                setTitle(nil, for: state)
                setAttributedTitle(attributedTitle, for: state)
            }
        }
    }

    public func setEditTitle(_ editTitle: EditText?, for state: UIControl.State) {
        if let editTitle = editTitle {
            switch editTitle {
            case .normal(let title, _):
                setTitle(title, for: state)
            case .attributed(let attributedTitle):
                setAttributedTitle(attributedTitle, for: state)
            }
        } else {
            setAttributedTitle(nil, for: state)
            setTitle(nil, for: state)
        }
    }
}
