// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class TextField: UITextField {
    public var leftAccessory: TextFieldAccessory? {
        didSet {
            leftView = leftAccessory?.content
            leftViewMode = leftAccessory?.mode ?? .never
        }
    }
    public var rightAccessory: TextFieldAccessory? {
        didSet {
            rightView = rightAccessory?.content
            rightViewMode = rightAccessory?.mode ?? .never
        }
    }

    public var contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    public var textEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: calculateFinalEdgeInsets(isEditing: false))
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).inset(by: calculateFinalEdgeInsets(isEditing: true))
    }

    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let accessory = leftAccessory else {
            return super.leftViewRect(forBounds: bounds)
        }
        let size = accessory.size ?? accessory.content.bounds.size
        return CGRect(
            x: contentEdgeInsets.left,
            y: contentEdgeInsets.top + ((bounds.height - size.height) / 2.0).ceil(),
            width: size.width,
            height: size.height
        )
    }

    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let accessory = rightAccessory else {
            return super.leftViewRect(forBounds: bounds)
        }
        let size = accessory.size ?? accessory.content.bounds.size
        return CGRect(
            x: bounds.width - size.width - contentEdgeInsets.right,
            y: contentEdgeInsets.top + ((bounds.height - size.height) / 2.0).ceil(),
            width: size.width,
            height: size.height
        )
    }
}

extension TextField {
    private func calculateFinalEdgeInsets(isEditing: Bool) -> UIEdgeInsets {
        var finalEdgeInsets = UIEdgeInsets(
            top: contentEdgeInsets.top + textEdgeInsets.top,
            left: textEdgeInsets.left,
            bottom: contentEdgeInsets.bottom + textEdgeInsets.bottom,
            right: textEdgeInsets.right
        )

        if leftView == nil {
            finalEdgeInsets.left += contentEdgeInsets.left
        }
        if rightView == nil {
            if isEditing {
                finalEdgeInsets.right += clearButtonMode == .never ? contentEdgeInsets.right : 0.0
            } else {
                finalEdgeInsets.right += contentEdgeInsets.right
            }
        }
        return finalEdgeInsets
    }
}

public struct TextFieldAccessory {
    let content: UIView
    let mode: UITextField.ViewMode
    let size: CGSize?

    public init(
        content: UIView,
        mode: UITextField.ViewMode = .always,
        size: CGSize? = nil
    ) {
        self.content = content
        self.mode = mode
        self.size = size
    }
}
