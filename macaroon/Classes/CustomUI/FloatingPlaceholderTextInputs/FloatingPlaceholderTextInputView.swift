// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MaterialComponents.MaterialTextControls_FilledTextFields
import SnapKit
import UIKit

open class FloatingPlaceholderTextInputView: View {
    public var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            updateTextInputLayoutWhenContentEdgeInsetsDidChange()
        }
    }

    public var leftAccessory: TextFieldAccessory? {
        didSet {
            textInputView.leadingView = leftAccessory?.content
            textInputView.leadingViewMode = leftAccessory?.mode ?? .never
        }
    }
    public var rightAccessory: TextFieldAccessory? {
        didSet {
            textInputView.trailingView = rightAccessory?.content
            textInputView.trailingViewMode = rightAccessory?.mode ?? .never
        }
    }

    public var text: String? {
        get { textInputView.text }
        set { textInputView.text = newValue }
    }
    public var attributedText: NSAttributedString? {
        get { textInputView.attributedText }
        set { textInputView.attributedText = newValue }
    }
    public var editText: EditText? {
        get { textInputView.editText }
        set { textInputView.editText = newValue }
    }

    public weak var textInputDelegate: UITextFieldDelegate? {
        get { textInputView.delegate }
        set { textInputView.delegate = newValue }
    }

    public var isEditing: Bool { textInputView.isEditing }
    public var editableView: UIView { textInputView }

    private lazy var textInputCanvasView = UIView()
    private lazy var textInputView = MDCFilledTextField()
    private lazy var editingIndicator = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }

    open func customizeAppearance(_ styleGuide: FloatingPlaceholderTextInputViewStyleGuideConvertible) {
        customizeBaseAppearance(styleGuide)
        customizeTextInputAppearance(styleGuide)
        customizeEditingIndicatorAppearance(styleGuide)
    }

    open func prepareLayout() {
        addTextInput()
        addEditingIndicator()
    }

    open func prepareLayout(_ layoutGuide: NoLayoutGuide) {
        prepareLayout()
    }

    @discardableResult
    open func beginEditing() -> Bool {
        return textInputView.becomeFirstResponder()
    }

    @discardableResult
    open func endEditing() -> Bool {
        return textInputView.resignFirstResponder()
    }
}

extension FloatingPlaceholderTextInputView {
    private func customizeTextInputAppearance(_ styleGuide: FloatingPlaceholderTextInputViewStyleGuideConvertible) {
        let style = styleGuide.getInput()

        textInputView.customizeBaseAppearance(style)

        textInputView.setFilledBackgroundColor(.clear, for: .normal)
        textInputView.setFilledBackgroundColor(.clear, for: .editing)
        textInputView.setFilledBackgroundColor(.clear, for: .disabled)
        textInputView.setUnderlineColor(.clear, for: .normal)
        textInputView.setUnderlineColor(.clear, for: .editing)
        textInputView.setUnderlineColor(.clear, for: .disabled)

        if let background = style.background?.normal {
            textInputView.background = background
        }
        if let disabledBackground = style.background?.disabled {
            textInputView.disabledBackground = disabledBackground
        }
        if let font = style.font?.normal {
            textInputView.font = font.preferred
            textInputView.adjustsFontForContentSizeCategory = font.adjustsFontForContentSizeCategory
        }
        if let normalTextColor = style.textColor?.normal {
            textInputView.setTextColor(normalTextColor, for: .normal)
            textInputView.setTextColor(normalTextColor, for: .editing)
            textInputView.setTextColor(normalTextColor, for: .disabled)
        }
        if let selectedTextColor = style.textColor?.selected {
            textInputView.setTextColor(selectedTextColor, for: .editing)
        }
        if let disabledTextColor = style.textColor?.disabled {
            textInputView.setTextColor(disabledTextColor, for: .disabled)
        }
        if let placeholderText = style.placeholderText {
            switch placeholderText {
            case .normal(let text, _):
                textInputView.label.text = text

                if let normalPlaceholderColor = style.placeholderColor?.normal {
                    textInputView.setNormalLabelColor(normalPlaceholderColor, for: .normal)
                    textInputView.setNormalLabelColor(normalPlaceholderColor, for: .editing)
                    textInputView.setNormalLabelColor(normalPlaceholderColor, for: .disabled)

                    textInputView.setFloatingLabelColor(normalPlaceholderColor, for: .normal)
                    textInputView.setFloatingLabelColor(normalPlaceholderColor, for: .editing)
                    textInputView.setFloatingLabelColor(normalPlaceholderColor, for: .disabled)
                }
                if let selectedPlaceholderColor = style.placeholderColor?.selected {
                    textInputView.setNormalLabelColor(selectedPlaceholderColor, for: .editing)
                    textInputView.setFloatingLabelColor(selectedPlaceholderColor, for: .editing)
                }
                if let disabledPlaceholderColor = style.placeholderColor?.disabled {
                    textInputView.setNormalLabelColor(disabledPlaceholderColor, for: .disabled)
                    textInputView.setFloatingLabelColor(disabledPlaceholderColor, for: .disabled)
                }
            case .attributed(let attributedText):
                textInputView.label.attributedText = attributedText
            }
        }
        textInputView.textAlignment = style.textAlignment
        textInputView.clearButtonMode = style.clearButtonMode
        textInputView.keyboardType = style.keyboardType
        textInputView.autocapitalizationType = style.autocapitalizationType
        textInputView.autocorrectionType = style.autocorrectionType
        textInputView.returnKeyType = style.returnKeyType
    }

    private func customizeEditingIndicatorAppearance(_ styleGuide: FloatingPlaceholderTextInputViewStyleGuideConvertible) {
        editingIndicator.customizeBaseAppearance(styleGuide.getEditingIndicator())
    }
}

extension FloatingPlaceholderTextInputView {
    private func addTextInput() {
        addSubview(textInputCanvasView)
        textInputCanvasView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }

        textInputCanvasView.addSubview(textInputView)
        textInputView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }

        updateTextInputLayoutWhenContentEdgeInsetsDidChange()
    }

    private func updateTextInputLayoutWhenContentEdgeInsetsDidChange() {
        textInputView.leadingEdgePaddingOverride = NSNumber(value: Double(contentEdgeInsets.left))
        textInputView.trailingEdgePaddingOverride = NSNumber(value: Double(contentEdgeInsets.right))

        textInputView.snp.updateConstraints { maker in
            maker.top.equalToSuperview().inset(contentEdgeInsets.top)
            maker.bottom.equalToSuperview().inset(contentEdgeInsets.bottom)
        }
    }

    private func addEditingIndicator() {
        addSubview(editingIndicator)
        editingIndicator.snp.makeConstraints { maker in
            maker.height.equalTo(1.0)
            maker.leading.equalTo(textInputCanvasView)
            maker.bottom.equalTo(textInputCanvasView)
            maker.trailing.equalTo(textInputCanvasView)
        }
    }
}
