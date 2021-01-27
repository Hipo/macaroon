// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Customizable: UIView {
    func resetAppearance()
}

extension Customizable {
    public func resetAppearance() {
        resetBaseAppearance()
    }
}

extension Customizable {
    public func customizeBaseAppearance(
        backgroundColor: Color?
    ) {
        self.backgroundColor = backgroundColor?.origin
    }

    public func customizeBaseAppearance(
        tintColor: Color?
    ) {
        self.tintColor = tintColor?.origin
    }

    public func customizeBaseAppearance(
        border: Border?
    ) {
        guard let border = border else {
            eraseBorder()
            return
        }

        draw(
            border
        )
    }

    public func customizeBaseAppearance(
        corner: Corner?
    ) {
        guard let corner = corner else {
            eraseCorner()
            return
        }

        draw(
            corner
        )
    }

    public func customizeBaseAppearance(
        shadow: Shadow?
    ) {
        guard let shadow = shadow else {
            eraseShadow()
            return
        }

        draw(
            shadow
        )
    }
}

extension Customizable {
    func resetBaseAppearance() {
        customizeBaseAppearance(
            backgroundColor: nil
        )
        customizeBaseAppearance(
            tintColor: nil
        )
        customizeBaseAppearance(
            border: nil
        )
        customizeBaseAppearance(
            corner: nil
        )
        customizeBaseAppearance(
            shadow: nil
        )
    }
}

extension UIView: Customizable {}
