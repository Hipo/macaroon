// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public protocol FormFieldView: UIView {}

public protocol FormInputFieldView: FormFieldView {
    typealias EditingHandler = (FormInputFieldView) -> Void

    /// <warning>
    /// The conforming input field views should call the delegate methods for the regarding events.
    var editingDelegate: FormInputFieldViewEditingDelegate? { get set }
    var inputState: FormInputFieldState { get set }

    var validator: Validator? { get set }

    var inputType: FormInputType { get }
    var isEditing: Bool { get }

    func beginEditing()
    func endEditing()

    func editingRect(in view: UIView) -> CGRect?
}

extension FormInputFieldView {
    public var isEditing: Bool {
        switch inputState {
        case .focus: return true
        default: return false
        }
    }
}

extension FormInputFieldView {
    public func editingRect(
        in view: UIView
    ) -> CGRect? {
        return superview?.convert(
            frame,
            to: view
        )
    }
}

public protocol FormTextInputFieldView: FormInputFieldView {
    var text: String? { get set }
    var formatter: TextInputFormatter? { get set }
}

public protocol FormNumberInputFieldView: FormInputFieldView {
    var text: String? { get set }
    var number: NSNumber? { get set }
    var formatter: NumberInputFormatter? { get set }
}

public protocol FormSingleSelectionInputFieldView: FormInputFieldView {
    var selectedIndex: Int? { get set }
}

public protocol FormToggleInputFieldView: FormInputFieldView {
    var isSelected: Bool { get set }
}

public protocol FormInputFieldViewEditingDelegate: AnyObject {
    func formInputFieldViewDidBeginEditing(_ view: FormInputFieldView)
    func formInputFieldViewDidEdit(_ view: FormInputFieldView)
    func formInputFieldViewDidEndEditing(_ view: FormInputFieldView)
}

public enum FormInputFieldState {
    case none
    case focus
    case invalid(ValidationError)
    case incorrect(EditText?)
}

public enum FormInputType {
    case none
    case keyboard
    case picker
    /// <note>
    /// The selection input types displayed inside the form, i.e. checkbox.
    case inSelection
    /// <note>
    /// The selection input types displayed outside the form, i.e. list
    case outSelection
}

extension FormInputType {
    public var requiresToBeVisible: Bool {
        switch self {
        case .keyboard,
             .picker:
            return true
        default:
            return false
        }
    }
}
