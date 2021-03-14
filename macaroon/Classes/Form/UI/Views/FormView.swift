// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class FormView:
    VStackView,
    FormInputFieldViewEditingDelegate {
    public weak var dataSource: FormViewDataSource? {
        didSet {
            if dataSource != nil {
                reloadData()
            }
        }
    }
    public weak var delegate: FormViewDelegate?

    public private(set) var inputFieldViews: [FormInputFieldView] = []

    public private(set) var editingInputFieldView: FormInputFieldView?

    public var isEditing: Bool {
        return editingInputFieldView != nil
    }

    public var previousEditingInputFieldView: FormInputFieldView? {
        guard let editingInputFieldView = editingInputFieldView else {
            return lastEditingInputFieldView ?? inputFieldViews.first
        }

        let foundEditingInputFieldIndex =
            inputFieldViews.firstIndex(
                where: {
                    $0 === editingInputFieldView
                }
            )

        guard let editingInputFieldIndex = foundEditingInputFieldIndex else {
            return nil
        }

        return inputFieldViews.previousElement(
            beforeElementAt: editingInputFieldIndex
        )
    }
    public var nextEditingInputFieldView: FormInputFieldView? {
        guard let editingInputFieldView = editingInputFieldView else {
            return lastEditingInputFieldView ?? inputFieldViews.first
        }

        let foundEditingInputFieldIndex =
            inputFieldViews.firstIndex(
                where: {
                    $0 === editingInputFieldView
                }
            )

        guard let editingInputFieldIndex = foundEditingInputFieldIndex else {
            return nil
        }

        return inputFieldViews.nextElement(
            afterElementAt: editingInputFieldIndex
        )
    }

    private var lastEditingInputFieldView: FormInputFieldView?

    private var fieldViewsRefTable: [String: UIView] = [:]

    public override init() {
        super.init()
        commonInit()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        alignment = .fill
        distribution = .fill
        spacing = 0.0
        isLayoutMarginsRelativeArrangement = true
    }

    open private(set) subscript<T: UIView>(
        field: FormField
    ) -> T {
        get {
            guard let anInputView = fieldViewsRefTable[field.rawValue] else {
                crash(
                    "Input view not found for \(field.rawValue)"
                )
            }

            guard let inputView = anInputView as? T else {
                crash(
                    "Actual input view (\(type(of: anInputView))) did not match the expected view (\(T.self)"
                )
            }

            return inputView
        }
        set {
            fieldViewsRefTable[field.rawValue] = newValue
        }
    }

    open func reloadData() {
        deleteAllSubviews()

        let someNewForm =
            dataSource?.form(
                in: self
            )

        guard let newForm = someNewForm else {
            return
        }

        newForm.elements.forEach {
            add(
                element: $0,
                in: self
            )
        }

        updateLayoutWhenFormDidChange(
            newForm
        )
    }

    /// <mark>
    /// FormInputFieldViewEditingDelegate
    open func formInputFieldViewDidBeginEditing(
        _ view: FormInputFieldView
    ) {
        /// <note>
        /// The input fields with an external input has its own mechanism to notify the end of
        /// editing event, therefore, if the new editing input field has also an external input,
        /// the event will be triggered automatically, and the result action will be taken in
        /// `formInputFieldViewDidEndEditing(_:)`.
        if let currentEditingInputFieldView = editingInputFieldView {
            if !currentEditingInputFieldView.inputType.isExternal ||
               !view.inputType.isExternal {
                currentEditingInputFieldView.endEditing()
            }
        }

        view.inputState = .focus

        editingInputFieldView = view
        lastEditingInputFieldView = view

        delegate?.formView(
            self,
            didBeginEditing: view
        )
    }

    open func formInputFieldViewDidEdit(
        _ view: FormInputFieldView
    ) {
        view.inputState = .focus

        delegate?.formView(
            self,
            didEdit: view
        )
    }

    open func formInputFieldViewDidEndEditing(
        _ view: FormInputFieldView
    ) {
        let shouldValidate =
            delegate?.formView(
                self,
                shouldValidate: view
            ) ?? true

        if shouldValidate {
            validate(
                view
            )
        } else {
            view.inputState = .none
        }

        if editingInputFieldView === view {
            editingInputFieldView = nil
        }

        delegate?.formView(
            self,
            didEndEditing: view
        )
    }
}

extension FormView {
    public func beginEditing() {
        (lastEditingInputFieldView ?? inputFieldViews.first)?.beginEditing()
    }

    public func beginPreviousEditing() {
        previousEditingInputFieldView?.beginEditing()
    }

    public func beginNextEditing() {
        nextEditingInputFieldView?.beginEditing()
    }

    public func endEditing() {
        editingInputFieldView?.endEditing()
    }
}

extension FormView {
    @discardableResult
    public func validateAll() -> Bool {
        return inputFieldViews.allSatisfy(validate)
    }

    @discardableResult
    public func validate(
        _ inputFieldView: FormInputFieldView
    ) -> Bool {
        guard let validator = inputFieldView.validator else {
            inputFieldView.inputState = .none
            return true
        }

        let validation =
            validator.validate(
                inputFieldView
            )

        switch validation {
        case .success:
            inputFieldView.inputState = .none
            return true
        case .failure(let error):
            inputFieldView.inputState = .invalid(error)
            return false
        }
    }
 }

extension FormView {
    private func updateLayoutWhenFormDidChange(
        _ newForm: Form
    ) {
        directionalLayoutMargins = NSDirectionalEdgeInsets(newForm.contentInset)
        isLayoutMarginsRelativeArrangement = true
    }

    @discardableResult
    private func add(
        element: Form.Element,
        in view: UIStackView
    ) -> UIView? {
        switch element {
        case .field(let identifier):
            return addField(
                identifier,
                in: view
            )
        case .hGroup(let items):
            return addHGroup(
                items,
                in: view
            )
        case .vGroup(let items):
            return addVGroup(
                items,
                in: view
            )
        case .fixedSpace(let spacing):
            addFixedSpace(
                spacing,
                in: view
            )
            return nil
        case .separator(let separator, let margin):
            addSeparator(
                separator,
                margin,
                in: view
            )
            return nil
        }
    }

    private func addField(
        _ field: FormField,
        in view: UIStackView
    ) -> UIView? {
        let someFieldView =
            dataSource?.fieldView(
                for: field,
                in: self
            )

        guard let fieldView = someFieldView else {
            return nil
        }

        view.addArrangedSubview(
            fieldView
        )

        self[field] = fieldView

        if let inputFieldView = fieldView as? FormInputFieldView {
            inputFieldView.editingDelegate = self
            inputFieldViews.append(inputFieldView)
        }

        return fieldView
    }

    private func addHGroup(
        _ items: [(subelement: Form.Element, proportion: CGFloat)],
        in view: UIStackView
    ) -> UIStackView {
        let hGroupView = HStackView()
        hGroupView.alignment = .top

        view.addArrangedSubview(
            hGroupView
        )

        addGroupItems(
            items,
            in: hGroupView
        )

        return hGroupView
    }

    private func addVGroup(
        _ items: [(subelement: Form.Element, proportion: CGFloat)],
        in view: UIStackView
    ) -> UIStackView {
        let vGroupView = VStackView()
        vGroupView.alignment = .leading

        view.addArrangedSubview(
            vGroupView
        )

        addGroupItems(
            items,
            in: vGroupView
        )

        return vGroupView
    }

    private func addGroupItems(
        _ items: [(subelement: Form.Element, proportion: CGFloat)],
        in groupView: UIStackView
    ) {
        let spacings: [CGFloat] = items.compactMap {
            switch $0.subelement {
            case .fixedSpace(let spacing): return spacing
            default: return nil
            }
        }
        let totalSpacing: CGFloat = spacings.reduce(0, +)
        let numberOfItems = items.count - spacings.count
        let proportionOffset = totalSpacing / CGFloat(numberOfItems)

        items.forEach { item in
            guard let fieldView =
                    add(
                        element: item.subelement,
                        in: groupView
                    )
            else {
                return
            }

            switch groupView.axis {
            case .horizontal:
                fieldView.snp.makeConstraints {
                    $0.width == groupView.snp.width * item.proportion - proportionOffset
                }
            case .vertical:
                fieldView.snp.makeConstraints {
                    $0.height == groupView.snp.height * item.proportion - proportionOffset
                }
            }
        }
    }

    private func addFixedSpace(
        _ spacing: CGFloat,
        in view: UIStackView
    ) {
        guard let lastArrangedView = view.arrangedSubviews.last else {
            return
        }

        view.setCustomSpacing(
            spacing,
            after: lastArrangedView
        )
    }

    private func addSeparator(
        _ separator: Separator,
        _ margin: CGFloat,
        in view: UIStackView
    ) {
        guard let lastArrangedView = view.arrangedSubviews.last else {
            return
        }

        /// <todo>
        /// Add the sepearator as an arranged view not subview.
        view.attachSeparator(
            separator,
            to: lastArrangedView,
            margin: margin
        )
    }
}

public protocol FormViewDataSource: AnyObject {
    func form(in formView: FormView) -> Form
    func fieldView(for field: FormField, in formView: FormView) -> FormFieldView?
}

public protocol FormViewDelegate: AnyObject {
    func formView(_ view: FormView, didBeginEditing inputFieldView: FormInputFieldView)
    func formView(_ view: FormView, didEdit inputFieldView: FormInputFieldView)
    func formView(_ view: FormView, shouldValidate inputFieldView: FormInputFieldView) -> Bool
    func formView(_ view: FormView, didEndEditing inputFieldView: FormInputFieldView)
}
