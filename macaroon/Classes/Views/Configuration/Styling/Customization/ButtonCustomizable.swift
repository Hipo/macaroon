// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ButtonCustomizable: Customizable {
    func customizeAppearance(_ style: ButtonStyling)
    func resetAppearance()
}

extension ButtonCustomizable where Self: UIButton {
    public func customizeAppearance(_ style: ButtonStyling) {
        customizeBaseAppearance(style)

        if let background = style.background?.normal {
            setBackgroundImage(background, for: .normal)
        }
        if let background = style.background?.highlighted {
            setBackgroundImage(background, for: .highlighted)
        }
        if let background = style.background?.selected {
            setBackgroundImage(background, for: .selected)
            setBackgroundImage(background, for: [.selected, .highlighted])
        }
        if let background = style.background?.disabled {
            setBackgroundImage(background, for: .disabled)
        }
        if let icon = style.icon?.normal {
            setImage(icon, for: .normal)
        }
        if let icon = style.icon?.highlighted {
            setImage(icon, for: .highlighted)
        }
        if let icon = style.icon?.selected {
            setImage(icon, for: .selected)
            setImage(icon, for: [.selected, .highlighted])
        }
        if let icon = style.icon?.disabled {
            setImage(icon, for: .disabled)
        }
        if let font = style.font?.normal {
            titleLabel?.font = font.preferred
        }
        if let textColor = style.textColor?.normal {
            setTitleColor(textColor, for: .normal)
        }
        if let textColor = style.textColor?.highlighted {
            setTitleColor(textColor, for: .highlighted)
        }
        if let textColor = style.textColor?.selected {
            setTitleColor(textColor, for: .selected)
            setTitleColor(textColor, for: [.selected, .highlighted])
        }
        if let textColor = style.textColor?.disabled {
            setTitleColor(textColor, for: .disabled)
        }
        if let title = style.title?.normal {
            setEditTitle(title, for: .normal)
        }
        if let title = style.title?.highlighted {
            setEditTitle(title, for: .highlighted)
        }
        if let title = style.title?.selected {
            setEditTitle(title, for: .selected)
            setEditTitle(title, for: [.selected, .highlighted])
        }
        if let title = style.title?.disabled {
            setEditTitle(title, for: .disabled)
        }
    }

    public func resetAppearance() {
        resetBaseAppearance()

        setBackgroundImage(nil, for: .normal)
        setBackgroundImage(nil, for: .highlighted)
        setBackgroundImage(nil, for: .selected)
        setBackgroundImage(nil, for: [.selected, .highlighted])
        setBackgroundImage(nil, for: .disabled)
        setImage(nil, for: .normal)
        setImage(nil, for: .highlighted)
        setImage(nil, for: .selected)
        setImage(nil, for: [.selected, .highlighted])
        setImage(nil, for: .disabled)
        titleLabel?.font = nil
        setTitleColor(nil, for: .normal)
        setTitleColor(nil, for: .highlighted)
        setTitleColor(nil, for: .selected)
        setTitleColor(nil, for: [.selected, .highlighted])
        setTitleColor(nil, for: .disabled)
        setEditTitle(nil, for: .normal)
        setEditTitle(nil, for: .highlighted)
        setEditTitle(nil, for: .selected)
        setEditTitle(nil, for: [.selected, .highlighted])
        setEditTitle(nil, for: .disabled)
    }
}

extension UIButton: ButtonCustomizable { }
