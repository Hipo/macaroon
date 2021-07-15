// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Customizable where Self: UIButton {
    public func customizeAppearance(
        _ style: ButtonStyle
    ) {
        customizeBaseAppearance(font: style.font)
        customizeBaseAppearance(titleColor: style.titleColor)
        customizeBaseAppearance(title: style.title)
        customizeBaseAppearance(icon: style.icon)
        customizeBaseAppearance(backgroundImage: style.backgroundImage)
        customizeBaseAppearance(backgroundColor: style.backgroundColor)
        customizeBaseAppearance(tintColor: style.tintColor)
        customizeBaseAppearance(isInteractable: style.isInteractable)
    }

    public func recustomizeAppearance(
        _ style: ButtonStyle
    ) {
        resetAppearance()
        customizeAppearance(
            style
        )
    }

    public func resetAppearance() {
        resetBaseAppearance()

        customizeBaseAppearance(
            backgroundImage: nil
        )
        customizeBaseAppearance(
            icon: nil
        )
        customizeBaseAppearance(
            font: nil
        )
        customizeBaseAppearance(
            titleColor: nil
        )
        customizeBaseAppearance(
            title: nil
        )
    }
}

extension Customizable where Self: UIButton {
    public func customizeBaseAppearance(
        backgroundImage: Image?
    ) {
        setBackgroundImage(
            backgroundImage?.image,
            for: .normal
        )
        setBackgroundImage(
            backgroundImage?.highlighted,
            for: .highlighted
        )
        setBackgroundImage(
            backgroundImage?.selected,
            for: .selected
        )
        setBackgroundImage(
            backgroundImage?.selected,
            for: [.selected, .highlighted]
        )
        setBackgroundImage(
            backgroundImage?.disabled,
            for: .disabled
        )
    }

    public func customizeBaseAppearance(
        icon: Image?
    ) {
        setImage(
            icon?.image,
            for: .normal
        )
        setImage(
            icon?.highlighted,
            for: .highlighted
        )
        setImage(
            icon?.selected,
            for: .selected
        )
        setImage(
            icon?.selected,
            for: [.selected, .highlighted]
        )
        setImage(
            icon?.disabled,
            for: .disabled
        )
    }

    public func customizeBaseAppearance(
        font: Font?
    ) {
        titleLabel?.font = font?.font
    }

    public func customizeBaseAppearance(
        titleColor: Color?
    ) {
        setTitleColor(
            titleColor?.color,
            for: .normal
        )
        setTitleColor(
            titleColor?.highlighted,
            for: .highlighted
        )
        setTitleColor(
            titleColor?.selected,
            for: .selected
        )
        setTitleColor(
            titleColor?.selected,
            for: [.selected, .highlighted]
        )
        setTitleColor(
            titleColor?.disabled,
            for: .disabled
        )
    }

    public func customizeBaseAppearance(
        title: Text?
    ) {
        setEditTitle(
            title?.text,
            for: .normal
        )
        setEditTitle(
            title?.highlighted,
            for: .highlighted
        )
        setEditTitle(
            title?.selected,
            for: .selected
        )
        setEditTitle(
            title?.selected,
            for: [.selected, .highlighted]
        )
        setEditTitle(
            title?.disabled,
            for: .disabled
        )
    }
}
