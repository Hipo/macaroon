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
        backgroundImage: StateImageGroup?
    ) {
        backgroundImage?.forEach {
            setBackgroundImage(
                $0.uiImage,
                for: $0.state
            )

            if $0.state == .selected {
                setBackgroundImage(
                    $0.uiImage,
                    for: [.selected, .highlighted]
                )
            }
        }
    }

    public func customizeBaseAppearance(
        icon: StateImageGroup?
    ) {
        icon?.forEach {
            setImage(
                $0.uiImage,
                for: $0.state
            )

            if $0.state == .selected {
                setImage(
                    $0.uiImage,
                    for: [.selected, .highlighted]
                )
            }
        }
    }

    public func customizeBaseAppearance(
        font: Font?
    ) {
        titleLabel?.font = font?.uiFont
    }

    public func customizeBaseAppearance(
        titleColor: StateColorGroup?
    ) {
        titleColor?.forEach {
            setTitleColor(
                $0.uiColor,
                for: $0.state
            )

            if $0.state == .selected {
                setTitleColor(
                    $0.uiColor,
                    for: [.selected, .highlighted]
                )
            }
        }
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
