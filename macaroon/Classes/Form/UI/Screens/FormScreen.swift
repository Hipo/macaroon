// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class FormScreen:
    ScrollScreen,
    FormViewDataSource,
    FormViewDelegate,
    KeyboardControllerDataSource {
    public typealias ScreenChangesAlongsideKeyboardTransition =
        ((keyboard: Keyboard, animated: Bool)) -> Void

    public var form: Form = []

    public var screenChangesAlongsideWhenKeyboardIsShowing:
        ScreenChangesAlongsideKeyboardTransition?
    public var screenChangesAlongsideWhenKeyboardIsHiding:
        ScreenChangesAlongsideKeyboardTransition?

    public private(set) lazy var formView = FormView()

    public private(set) lazy var keyboardController =
        KeyboardController(scrollView: scrollView, screen: self)

    public let fieldViewGenerator: FormFieldViewGenerator

    public init(
        fieldViewGenerator: FormFieldViewGenerator,
        configurator: ScreenConfigurable?
    ) {
        self.fieldViewGenerator = fieldViewGenerator

        super.init(
            configurator: configurator
        )

        keyboardController.activate()
    }

    deinit {
        keyboardController.deactivate()
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

    open override func addScroll() {
        super.addScroll()

        scrollView.autoScrollsToFirstResponder = false

        if #available(iOS 13, *) {}
        else {
            /// <warning>
            /// iOS 12
            /// It is a temporary solution. Keyboard notifications aren't fired unless the keyboard
            /// state doesn't change (open <-> close). Therefore, if there is any action on the
            /// screen which should pin to the keyboard, and it won't, then at least we will have
            /// a way to close the keyboard.
            scrollView.keyboardDismissMode = .interactive
        }
    }

    open override func updateScrollLayoutWhenViewDidLayoutSubviews() {
        if formView.isEditing {
            return
        }

        scrollView.setContentInset(
            bottom: bottomInsetWhenKeyboardDidHide(
                keyboardController
            )
        )
    }

    open func addForm() {
        contentView.addSubview(
            formView
        )
        formView.snp.makeConstraints {
            $0.setPaddings((0, 0, 0, 0))
        }
    }

    open override func viewWillAppear(
        _ animated: Bool
    ) {
        super.viewWillAppear(
            animated
        )

        /// <note>
        /// It is required if the form is being edited in `viewWillAppear`.
        registerScreenChangesAlongsideKeyboardTransition(
            first: !isViewPopped
        )
    }

    open override func viewDidAppear(
        _ animated: Bool
    ) {
        super.viewDidAppear(
            animated
        )

        registerScreenChangesAlongsideKeyboardTransition(
            first: false
        )
    }

    open override func viewDidDisappear(
        _ animated: Bool
    ) {
        super.viewDidDisappear(
            animated
        )

        keyboardController.reset()
    }

    /// <mark>
    /// FormViewDataSource
    open func form(
        in formView: FormView
    ) -> Form {
        return form
    }

    open func fieldView(
        for field: FormField,
        in formView: FormView
    ) -> FormFieldView? {
        return fieldViewGenerator.makeFieldView(
            for: field
        )
    }

    /// <mark>
    /// FormViewDelegate
    open func formView(
        _ view: FormView,
        didBeginEditing inputFieldView: FormInputFieldView
    ) {
        keyboardController.scrollToEditingRect(
            afterContentDidChange: false,
            animated: true
        )
    }

    open func formView(
        _ view: FormView,
        didEdit inputFieldView: FormInputFieldView
    ) {}

    public func formView(
        _ view: FormView,
        shouldValidate inputFieldView: FormInputFieldView
    ) -> Bool {
        return !(
            isViewDisappearing ||
            isViewDisappeared
        )
    }

    open func formView(
        _ view: FormView,
        didEndEditing inputFieldView: FormInputFieldView
    ) {}

    /// <mark>
    /// KeyboardControllerDataSource
    open func keyboardController(
        _ keyboardController: KeyboardController,
        editingRectIn view: UIView
    ) -> CGRect? {
        guard let editingInputFieldView = formView.editingInputFieldView else {
            return nil
        }

        if !editingInputFieldView.inputType.isExternal {
            return nil
        }

        return editingInputFieldView.editingRect(
            in: view
        )
    }

    open func bottomInsetOverKeyboardWhenKeyboardDidShow(
        _ keyboardController: KeyboardController
    ) -> LayoutMetric {
        return 8
    }

    open func bottomInsetUnderKeyboardWhenKeyboardDidShow(
        _ keyboardController: KeyboardController
    ) -> LayoutMetric {
        return 0
    }

    open func bottomInsetWhenKeyboardDidHide(
        _ keyboardController: KeyboardController
    ) -> LayoutMetric {
        return 0
    }
}

extension FormScreen {
    /// <note>
    /// It is recommended to be called in `viewWillAppear(_:).
    public func beginEditing() {
        /// <warning>
        /// Layout updates should be finalized immediately, not cause them to animate alongside
        /// the keyboard transitions.
        view.layoutIfNeeded()

        formView.beginEditing()
    }

    public func endEditing() {
        formView.endEditing()
    }
}

extension FormScreen {
    private func registerScreenChangesAlongsideKeyboardTransition(
        first: Bool
    ) {
        /// <note>
        /// Do not need an animated transition when the screen is first loaded.
        let isAnimated = !first

        if screenChangesAlongsideWhenKeyboardIsShowing != nil {
            keyboardController.performAlongsideWhenKeyboardIsShowing(
                animated: isAnimated
            ) { [unowned self] keyboard in
                self.screenChangesAlongsideWhenKeyboardIsShowing?(
                    (keyboard, isAnimated)
                )
            }
        }

        if screenChangesAlongsideWhenKeyboardIsHiding != nil {
            keyboardController.performAlongsideWhenKeyboardIsHiding(
                animated: isAnimated
            ) { [unowned self] keyboard in
                self.screenChangesAlongsideWhenKeyboardIsHiding?(
                    (keyboard, isAnimated)
                )
            }
        }
    }
}
