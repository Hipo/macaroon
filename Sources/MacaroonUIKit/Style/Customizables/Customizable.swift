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
        self.backgroundColor = backgroundColor?.color ?? .clear
    }

    public func customizeBaseAppearance(
        tintColor: Color?
    ) {
        self.tintColor = tintColor?.color
    }

    public func customizeBaseAppearance(
        isInteractable: Bool?
    ) {
        isUserInteractionEnabled = isInteractable ?? true
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
            isInteractable: nil
        )
    }
}

extension UIView: Customizable {}
