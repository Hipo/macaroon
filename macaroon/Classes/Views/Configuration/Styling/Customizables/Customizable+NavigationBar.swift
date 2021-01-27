// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Customizable where Self: UINavigationBar {
    public func customizeAppearance(
        _ style: NavigationBarStyle
    ) {
        style.forEach {
            switch $0 {
            case .backgroundColor(let backgroundColor):
                customizeBarAppearance(
                    backgroundColor: backgroundColor
                )
            case .tintColor(let tintColor):
                customizeBarAppearance(
                    tintColor: tintColor
                )
            case .border:
                break
            case .corner:
                break
            case .shadow:
                break
            case .font(let font):
                customizeBarAppearance(
                    font: font
                )
            case .textColor(let textColor):
                customizeBarAppearance(
                    textColor: textColor
                )
            }
        }
    }

    public func recustomizeAppearance(
        _ style: NavigationBarStyle
    ) {
        resetAppearance()
        customizeAppearance(
            style
        )
    }

    public func resetAppearance() {
        resetBaseAppearance()

        customizeBarAppearance(
            backgroundColor: nil
        )
        customizeBarAppearance(
            tintColor: nil
        )
        customizeBarAppearance(
            font: nil
        )
        customizeBarAppearance(
            textColor: nil
        )
    }
}

extension Customizable where Self: UINavigationBar {
    public func customizeBarAppearance(
        backgroundColor: Color?
    ) {
        self.barTintColor = backgroundColor?.origin
    }

    public func customizeBarAppearance(
        tintColor: Color?
    ) {
        self.tintColor = tintColor?.origin
    }

    public func customizeBarAppearance(
        font: Font?
    ) {
        var titleTextAttributes = self.titleTextAttributes ?? [:]
        titleTextAttributes[.font] = font?.origin
        self.titleTextAttributes = titleTextAttributes
    }

    public func customizeBarAppearance(
        textColor: Color?
    ) {
        var titleTextAttributes = self.titleTextAttributes ?? [:]
        titleTextAttributes[.foregroundColor] = textColor?.origin
        self.titleTextAttributes = titleTextAttributes
    }
}
