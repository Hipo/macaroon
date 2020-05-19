// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Customizable {
    func customizeBaseAppearance(_ style: Styling)
    func resetBaseAppearance()
}

extension Customizable where Self: UIView {
    public func customizeBaseAppearance(_ style: Styling) {
        if let backgroundColor = style.backgroundColor?.normal {
            self.backgroundColor = backgroundColor
        }
        if let tintColor = style.tintColor?.normal {
            self.tintColor = tintColor
        }
        if let roundableView = self as? CornerRoundDrawable {
            if let cornerRound = style.cornerRound {
                roundableView.drawCornerRound(cornerRound)
            } else {
                roundableView.removeCornerRound()
            }
        }
        if let shadowDrawableView = self as? ShadowDrawable {
            if let shadow = style.shadow {
                shadowDrawableView.drawShadow(shadow)
            } else {
                shadowDrawableView.removeShadow()
            }
        }
    }

    public func resetBaseAppearance() {
        backgroundColor = nil
        tintColor = nil

        if let roundableView = self as? CornerRoundDrawable {
            roundableView.removeCornerRound()
        }
        if let shadowDrawableView = self as? ShadowDrawable {
            shadowDrawableView.removeShadow()
        }
    }
}

extension UIView: Customizable { }

extension UINavigationBar {
    public func customizeBarAppearance(_ style: TextStyling) {
        if let barTintColor = style.backgroundColor?.normal {
            self.barTintColor = barTintColor
        }
        if let tintColor = style.tintColor?.normal {
            self.tintColor = tintColor
        }

        var titleTextAttributes: [NSAttributedString.Key: Any] = [:]

        if let textColor = style.textColor?.normal {
            titleTextAttributes[.foregroundColor] = textColor
        }
        if let font = style.font?.normal {
            titleTextAttributes[.font] = font.preferred
        }
        self.titleTextAttributes = titleTextAttributes
    }
}
