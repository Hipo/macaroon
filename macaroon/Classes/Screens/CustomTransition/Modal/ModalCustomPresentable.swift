// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ModalCustomPresentable: UIViewController {
    var presentedHeight: ModalHeight { get }
}

extension ModalCustomPresentable {
    /// <note>
    /// Should update `presentedHeight` before calling this method in order to see the changes.
    public func layoutPresentationIfNeeded(
        animated: Bool = true
    ) {
        guard let containerView = presentationController?.containerView else {
            return
        }

        containerView.setNeedsLayout()

        if !animated {
            containerView.layoutIfNeeded()
            return
        }

        let animator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.65) {
            containerView.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}

public enum ModalHeight: Equatable {
    /// <note>
    /// Smallest possible height
    case compressed
    /// <note>
    /// Largest possible height
    case expanded
    case proportional(LayoutMetric)
    case preferred(LayoutMetric)
}
