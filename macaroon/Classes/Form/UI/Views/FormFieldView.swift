// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol FormFieldView: UIView {}

public protocol FormInputFieldView: FormFieldView {
    typealias EditingHandler = (FormInputFieldView) -> Void

    /// <warning>
    /// The conforming input field views should call the delegate methods for the regarding events.
    var editingDelegate: FormInputFieldViewEditingDelegate? { get set }
    var state: FormInputFieldState { get set }

    var inputType: FormInputType { get }
    var isEditing: Bool { get }

    func beginEditing()
    func endEditing()
}

extension FormInputFieldView {
    public var isEditing: Bool {
        switch state {
        case .focus: return true
        default: return false
        }
    }
}

public protocol FormInputFieldViewEditingDelegate: AnyObject {
    func formInputFieldViewDidBeginEditing(_ formInputFieldView: FormInputFieldView)
    func formInputFieldViewDidEndEditing(_ formInputFieldView: FormInputFieldView)
}

public enum FormInputFieldState {
    case none
    case focus
    case invalid
    case incorrect
}

public enum FormInputType {
    case none
    case keyboard
    case inselection /// <note> The selection input types displayed inside the form, i.e. checkbox.
    case outselection /// <note> The selection input types displayed outside the form, i.e. picker.
}

extension FormInputType {
    public var isExternal: Bool {
        switch self {
        case .keyboard,
             .outselection: return true
        default: return false
        }
    }
}
