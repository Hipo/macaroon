// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Customizable where Self: UILabel {
    public func customizeAppearance(
        _ style: TextStyle
    ) {
        style.forEach {
            switch $0 {
            case .backgroundColor(let backgroundColor):
                customizeBaseAppearance(
                    backgroundColor: backgroundColor
                )
            case .tintColor(let tintColor):
                customizeBaseAppearance(
                    tintColor: tintColor
                )
            case .isInteractable(let isInteractable):
                customizeBaseAppearance(
                    isInteractable: isInteractable
                )
            case .font(let font):
                customizeBaseAppearance(
                    font: font
                )
            case .adjustsFontForContentSizeCategory(let adjustsFontForContentSizeCategory):
                customizeBaseAppearance(
                    adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory
                )
            case .textAlignment(let textAlignment):
                customizeBaseAppearance(
                    textAlignment: textAlignment
                )
            case .textOverflow(let textOverflow):
                customizeBaseAppearance(
                    textOverflow: textOverflow
                )
            case .textColor(let textColor):
                customizeBaseAppearance(
                    textColor: textColor
                )
            case .content(let content):
                customizeBaseAppearance(
                    content: content
                )
            }
        }
    }

    public func recustomizeAppearance(
        _ style: TextStyle
    ) {
        resetAppearance()
        customizeAppearance(
            style
        )
    }

    public func resetAppearance() {
        resetBaseAppearance()

        customizeBaseAppearance(
            font: nil
        )
        customizeBaseAppearance(
            adjustsFontForContentSizeCategory: false
        )
        customizeBaseAppearance(
            textAlignment: nil
        )
        customizeBaseAppearance(
            textOverflow: nil
        )
        customizeBaseAppearance(
            textColor: nil
        )
        customizeBaseAppearance(
            content: nil
        )
    }
}

extension Customizable where Self: UILabel {
    public func customizeBaseAppearance(
        font: Font?
    ) {
        self.font = font?.font
        self.adjustsFontForContentSizeCategory = font?.adjustsFontForContentSizeCategory ?? false
    }

    public func customizeBaseAppearance(
        adjustsFontForContentSizeCategory: Bool
    ) {
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
    }

    public func customizeBaseAppearance(
        textAlignment: NSTextAlignment?
    ) {
        self.textAlignment = textAlignment ?? .left
    }

    public func customizeBaseAppearance(
        textOverflow: TextOverflow?
    ) {
        guard let textOverflow = textOverflow else {
            customizeBaseAppearance(
                textOverflow: .singleLine()
            )
            return
        }

        switch textOverflow {
        case .singleLine(let lineBreakMode):
            self.numberOfLines = 1
            self.lineBreakMode = lineBreakMode
        case .singleLineFitting:
            self.numberOfLines = 1
            self.lineBreakMode = .byTruncatingTail
            self.adjustsFontSizeToFitWidth = true
            self.minimumScaleFactor = 0.5
        case .multiline(let maxNumberOfLines, let lineBreakMode):
            self.numberOfLines = maxNumberOfLines
            self.lineBreakMode = lineBreakMode
        case .fitting:
            self.numberOfLines = 0
            self.lineBreakMode = .byWordWrapping
        }
    }

    public func customizeBaseAppearance(
        textColor: Color?
    ) {
        self.textColor = textColor?.color
    }

    public func customizeBaseAppearance(
        content: Text?
    ) {
        self.editText = content?.text
    }
}

extension Customizable where Self: UITextField {
    public func customizeAppearance(
        _ style: TextStyle
    ) {
        style.forEach {
            switch $0 {
            case .backgroundColor(let backgroundColor):
                customizeBaseAppearance(
                    backgroundColor: backgroundColor
                )
            case .tintColor(let tintColor):
                customizeBaseAppearance(
                    tintColor: tintColor
                )
            case .isInteractable(let isInteractable):
                customizeBaseAppearance(
                    isInteractable: isInteractable
                )
            case .font(let font):
                customizeBaseAppearance(
                    font: font
                )
            case .adjustsFontForContentSizeCategory(let adjustsFontForContentSizeCategory):
                customizeBaseAppearance(
                    adjustsFontForContentSizeCategory: adjustsFontForContentSizeCategory
                )
            case .textAlignment(let textAlignment):
                customizeBaseAppearance(
                    textAlignment: textAlignment
                )
            case .textOverflow:
                break
            case .textColor(let textColor):
                customizeBaseAppearance(
                    textColor: textColor
                )
            case .content(let content):
                customizeBaseAppearance(
                    content: content
                )
            }
        }
    }

    public func recustomizeAppearance(
        _ style: TextStyle
    ) {
        resetAppearance()
        customizeAppearance(
            style
        )
    }
}

extension Customizable where Self: UITextField {
    public func customizeBaseAppearance(
        adjustsFontForContentSizeCategory: Bool
    ) {
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
    }
}
