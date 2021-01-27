// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class FormView:
    VStackView,
    FormInputFieldViewEditingDelegate {
    public weak var dataSource: FormViewDataSource? {
        didSet {
            if dataSource == nil { return }
            reloadData()
        }
    }
    public weak var delegate: FormViewDelegate?

    public private(set) var inputFieldViews: [FormInputFieldView] = []

    public private(set) var editingInputFieldView: FormInputFieldView?

    public var previousEditingInputFieldView: FormInputFieldView? {
        guard let editingInputFieldView = editingInputFieldView else {
            return lastEditingInputFieldView ?? inputFieldViews.first
        }

        guard let editingInputFieldIndex =
                inputFieldViews.firstIndex(
                    where: {
                        $0 === editingInputFieldView
                    }
                )
        else { return nil }

        return inputFieldViews.previousElement(
            beforeElementAt: editingInputFieldIndex
        )
    }
    public var nextEditingInputFieldView: FormInputFieldView? {
        guard let editingInputFieldView = editingInputFieldView else {
            return lastEditingInputFieldView ?? inputFieldViews.first
        }

        guard let editingInputFieldIndex =
                inputFieldViews.firstIndex(
                    where: {
                        $0 === editingInputFieldView
                    }
                )
        else { return nil }

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
        identifier: FormFieldIdentifier
    ) -> T {
        get {
            guard let anInputView = fieldViewsRefTable[identifier.rawValue] else {
                crash(
                    "Input view not found for \(identifier.rawValue)"
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
            fieldViewsRefTable[identifier.rawValue] = newValue
        }
    }

    open func reloadData() {
        deleteAllSubviews()

        guard let newForm =
                dataSource?.form(
                    in: self
                )
        else { return }

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
        _ formInputFieldView: FormInputFieldView
    ) {
        /// <note>
        /// The input fields with an external input has its own mechanism to notify the end of
        /// editing event, therefore, if the new editing input field has also an external input,
        /// the event will be triggered automatically, and the result action will be taken in
        /// `formInputFieldViewDidEndEditing(_:)`.
        if let currentEditingInputFieldView = editingInputFieldView {
            if !currentEditingInputFieldView.inputType.isExternal ||
               !formInputFieldView.inputType.isExternal {
                currentEditingInputFieldView.endEditing()
            }
        }

        formInputFieldView.state = .focus

        editingInputFieldView = formInputFieldView
        lastEditingInputFieldView = formInputFieldView

        delegate?.formView(
            self,
            didBeginEditing: formInputFieldView
        )
    }

    open func formInputFieldViewDidEndEditing(
        _ formInputFieldView: FormInputFieldView
    ) {
        if editingInputFieldView === formInputFieldView {
            editingInputFieldView = nil
        }

        delegate?.formView(
            self,
            didEndEditing: formInputFieldView
        )
    }
}

extension FormView {
    public func beginEditing() {
        (lastEditingInputFieldView ?? inputFieldViews.first)?.beginEditing()
    }

    public func beginPreviousEditing(
        before inputFieldView: FormInputFieldView? = nil
    ) {
        guard let inputFieldView = inputFieldView else {
            previousEditingInputFieldView?.beginEditing()
            return
        }
    }

    public func beginNextEditing(
        after inputFieldView: FormInputFieldView? = nil
    ) {
        guard let inputFieldView = inputFieldView else {
            nextEditingInputFieldView?.beginEditing()
            return
        }
    }

    public func endEditing() {
        editingInputFieldView?.endEditing()
    }
}

extension FormView {
    private func updateLayoutWhenFormDidChange(
        _ newForm: Form
    ) {
        directionalLayoutMargins = NSDirectionalEdgeInsets(newForm.paddings)
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
        _ identifier: FormFieldIdentifier,
        in view: UIStackView
    ) -> UIView? {
        guard let fieldView =
                dataSource?.fieldView(
                    for: identifier,
                    in: self
                )
        else { return nil }

        view.addArrangedSubview(
            fieldView
        )

        self[identifier] = fieldView

        if let inputFieldView = fieldView as? FormInputFieldView {
            inputFieldView.editingDelegate = self
            inputFieldViews.append(inputFieldView)
        }

        return inputView
    }

    private func addHGroup(
        _ items: [(subelement: Form.Element, proportion: CGFloat)],
        in view: UIStackView
    ) -> UIStackView {
        let hGroupView = HStackView()

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
        let totalSpacing: CGFloat = spacings.reduce(0.0, +)
        let numberOfItems = items.count - spacings.count
        let proportionOffset = totalSpacing / CGFloat(numberOfItems)

        items.forEach { item in
            guard let fieldView =
                    add(
                        element: item.subelement,
                        in: groupView
                    )
            else { return }

            switch groupView.axis {
            case .horizontal:
                fieldView.snp.makeConstraints {
                    $0.width == snp.width * item.proportion + proportionOffset
                }
            case .vertical:
                fieldView.snp.makeConstraints {
                    $0.height == snp.height * item.proportion + proportionOffset
                }
            }
        }
    }

    private func addFixedSpace(
        _ spacing: CGFloat,
        in view: UIStackView
    ) {
        guard let lastArrangedView = view.arrangedSubviews.last else { return }

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
        guard let lastArrangedView = view.arrangedSubviews.last else { return }

        view.attachSeparator(
            separator,
            to: lastArrangedView,
            margin: margin
        )
    }
}

public protocol FormViewDataSource: AnyObject {
    func form(in formView: FormView) -> Form
    func fieldView(for identifier: FormFieldIdentifier, in formView: FormView) -> FormFieldView?
}

public protocol FormViewDelegate: AnyObject {
    func formView(_ formView: FormView, didBeginEditing inputFieldView: FormInputFieldView)
    func formView(_ formView: FormView, didEndEditing inputFieldView: FormInputFieldView)
}
