// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ModalCustomPresenter: UIPresentationController {
    func prepareForLayoutUpdates()
}

public protocol ModalCustomPresentable: UIViewController {
    var modalHeight: ModalHeight { get }
}

extension ModalCustomPresentable {
    /// <note>
    /// Should update `modalHeight` before calling this method in order to see the changes.
    public func performLayoutUpdates(
        animated: Bool = true
    ) {
        let presentationController = (navigationController ?? self).presentationController

        if let presenter = presentationController as? ModalCustomPresenter {
            presenter.prepareForLayoutUpdates()
        }

        guard let containerView = presentationController?.containerView else { return }

        containerView.setNeedsLayout()

        if !animated {
            containerView.layoutIfNeeded()
            return
        }

        view.layoutIfNeeded()

        let animator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.8) {
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

extension ModalHeight {
    var isExplicit: Bool {
        switch self {
        case .proportional, .preferred: return true
        default: return false
        }
    }
}
