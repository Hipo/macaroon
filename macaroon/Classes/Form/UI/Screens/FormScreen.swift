// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class FormScreen:
    ScrollScreen,
    FormViewDataSource,
    FormViewDelegate {
    public var form: Form = []

    public private(set) lazy var formView = FormView()

    public let fieldViewGenerator: FormFieldViewGenerator

    public init(
        fieldViewGenerator: FormFieldViewGenerator
    ) {
        self.fieldViewGenerator = fieldViewGenerator

        super.init()
    }

    open override func prepareLayout() {
        super.prepareLayout()
        addForm()
    }

    open override func setListeners() {
        super.setListeners()
        formView.dataSource = self
        formView.delegate = self
    }

    open func addForm() {
        contentView.addSubview(
            formView
        )
        formView.snp.makeConstraints {
            $0.setPaddings((0, 0, 0, 0))
        }
    }

    /// <mark>
    /// FormViewDataSource
    open func form(
        in formView: FormView
    ) -> Form {
        return form
    }

    open func fieldView(
        for identifier: FormFieldIdentifier,
        in formView: FormView
    ) -> FormFieldView? {
        return fieldViewGenerator.fieldView(
            for: identifier
        )
    }

    /// <mark>
    /// FormViewDelegate
    open func formView(
        _ formView: FormView,
        didBeginEditing inputFieldView: FormInputFieldView
    ) {}

    open func formView(
        _ formView: FormView,
        didEndEditing inputFieldView: FormInputFieldView
    ) {}
}
