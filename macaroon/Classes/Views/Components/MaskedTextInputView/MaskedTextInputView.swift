// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

/// <todo> Maybe it is more correct to subclass Control.
open class MaskedTextInputView: View {
    public var maskedText: String? {
        get { maskedTextInputView.text }
        set { maskedTextInputView.text = newValue }
    }
    public var attributedMaskedText: NSAttributedString? {
        get { maskedTextInputView.attributedText }
        set { maskedTextInputView.attributedText = newValue }
    }
    public var maskedEditText: EditText? {
        get {
            if let attributedMaskedText = attributedMaskedText {
                return .attributed(attributedMaskedText)
            }
            if let maskedText = maskedText {
                return .normal(maskedText, maskedTextInputView.font)
            }
            return nil
        }
        set {
            guard let maskedEditText = newValue else {
                maskedText = nil
                attributedMaskedText = nil
                return
            }
            switch maskedEditText {
            case .normal(let newMaskedText, _):
                attributedMaskedText = nil
                maskedText = newMaskedText
            case .attributed(let newAttributedMaskedText):
                maskedText = nil
                attributedMaskedText = newAttributedMaskedText
            }
        }
    }
    public var text: String? {
        get { textInputView.text }
        set {
            textInputView.text = newValue
            textInputDidChange()
        }
    }
    public var attributedText: NSAttributedString? {
        get { textInputView.attributedText }
        set {
            textInputView.attributedText = newValue
            textInputDidChange()
        }
    }
    public var editText: EditText? {
        get {
            if let attributedText = attributedText {
                return .attributed(attributedText)
            }
            if let text = text {
                return .normal(text, textInputView.font)
            }
            return nil
        }
        set {
            guard let editText = newValue else {
                text = nil
                attributedText = nil
                return
            }
            switch editText {
            case .normal(let newText, _):
                attributedText = nil
                text = newText
            case .attributed(let newAttributedText):
                text = nil
                attributedText = newAttributedText
            }
        }
    }
    public var textAlignment: NSTextAlignment {
        get { textInputView.textAlignment }
        set { textInputView.textAlignment = newValue }
    }

    public weak var delegate: MaskedTextInputViewDelegate?

    public var isEditing: Bool {
        return textInputView.isFirstResponder
    }

    private var textInputTrailingConstraint: Constraint?

    private lazy var maskedTextInputView = TextField()
    private lazy var textInputView = TextField()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
        setListeners()
        linkInteractors()
    }

    open func customizeAppearance(_ styleGuide: MaskedTextInputViewStyleGuideConvertible) {
        customizeBaseAppearance(styleGuide)
        customizeMaskedTextInputAppearance(styleGuide)
        customizeTextInputAppearance(styleGuide)
    }

    open func prepareLayout() {
        addMaskedTextInput()
        addTextInput()
    }

    open func setListeners() {
        textInputView.delegate = self
    }

    open func linkInteractors() {
        maskedTextInputView.isUserInteractionEnabled = false
    }

    open func textInputDidChange() {
        recustomizeAppearanceWhenTextInputDidChange()
        updateLayoutWhenTextInputDidChange()
    }
}

extension MaskedTextInputView {
    @discardableResult
    public func beginEditing() -> Bool {
        return textInputView.becomeFirstResponder()
    }

    @discardableResult
    public func endEditing() -> Bool {
        return textInputView.resignFirstResponder()
    }

    public func shiftCaretToPositionFromStart(byOffset offset: Int) {
        textInputView.shiftCaretToPositionFromStart(byOffset: offset)
    }
}

extension MaskedTextInputView {
    private func recustomizeAppearanceWhenTextInputDidChange() {
        recustomizeTextInputAppearanceWhenTextInputDidChange()
    }

    private func customizeMaskedTextInputAppearance(_ styleGuide: MaskedTextInputViewStyleGuideConvertible) {
        maskedTextInputView.customizeAppearance(styleGuide.getMaskedTextInput())
    }

    private func customizeTextInputAppearance(_ styleGuide: MaskedTextInputViewStyleGuideConvertible) {
        textInputView.customizeAppearance(styleGuide.getTextInput())
        recustomizeTextInputAppearanceWhenTextInputDidChange()
    }

    private func recustomizeTextInputAppearanceWhenTextInputDidChange() {
        textInputView.backgroundColor = editText.nonNil.isEmpty ? .clear : (backgroundColor ?? .white)
    }
}

extension MaskedTextInputView {
    private func updateLayoutWhenTextInputDidChange() {
        updateTextInputLayoutWhenTextInputDidChange()
    }

    private func addMaskedTextInput() {
        addSubview(maskedTextInputView)
        maskedTextInputView.setContentHuggingPriority(.required, for: .horizontal)
        maskedTextInputView.setContentHuggingPriority(.required, for: .vertical)
        maskedTextInputView.setContentCompressionResistancePriority(.required, for: .horizontal)
        maskedTextInputView.setContentCompressionResistancePriority(.required, for: .vertical)
        maskedTextInputView.contentEdgeInsets = .zero
        maskedTextInputView.textEdgeInsets = .zero
        maskedTextInputView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.lessThanOrEqualToSuperview()
        }
    }

    private func addTextInput() {
        addSubview(textInputView)
        textInputView.setContentCompressionResistancePriority(.required, for: .horizontal)
        textInputView.contentEdgeInsets = .zero
        textInputView.textEdgeInsets = .zero
        textInputView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.lessThanOrEqualToSuperview()

            textInputTrailingConstraint = maker.trailing.equalToSuperview().priority(999.0).constraint
        }

        updateTextInputLayoutWhenTextInputDidChange()
    }

    private func updateTextInputLayoutWhenTextInputDidChange() {
        if editText.nonNil.isEmpty {
            textInputTrailingConstraint?.activate()
        } else {
            textInputTrailingConstraint?.deactivate()
        }
        if superview != nil {
            layoutIfNeeded()
        }
    }
}

extension MaskedTextInputView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let shouldChange = delegate?.maskedTextInputView(self, shouldChangeCharactersIn: range, replacementString: string) ?? true

        if shouldChange {
            text = (textField.text as? NSString)?.replacingCharacters(in: range, with: string)
        }
        return false
    }
}

public protocol MaskedTextInputViewDelegate: AnyObject {
    func maskedTextInputView(_ view: MaskedTextInputView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

extension MaskedTextInputViewDelegate {
    public func maskedTextInputView(_ view: MaskedTextInputView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
