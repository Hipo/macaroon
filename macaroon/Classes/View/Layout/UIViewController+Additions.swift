// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

/// <mark> Containers
extension UIViewController {
    public func fitToContainer(_ child: UIViewController, insetBy margins: UIEdgeInsets = .zero) {
        add(child) { [unowned self] view in
            self.view.addSubview(view)
            view.fitToSuperview(insetBy: margins)
        }
    }

    public func insertToContainer(_ child: UIViewController, below frontChild: UIViewController, insetBy margins: UIEdgeInsets = .zero) {
        add(child) { [unowned self] view in
            self.view.insertSubview(view, belowSubview: frontChild.view)
            view.fitToSuperview(insetBy: margins)
        }
    }

    public func insertToContainer(_ child: UIViewController, above backChild: UIViewController, insetBy margins: UIEdgeInsets = .zero) {
        add(child) { [unowned self] view in
            self.view.insertSubview(view, aboveSubview: backChild.view)
            view.fitToSuperview(insetBy: margins)
        }
    }

    public func add(_ child: UIViewController, prepareLayout: (UIView) -> Void) {
        addChild(child)
        prepareLayout(child.view)
        child.didMove(toParent: self)
    }

    public func removeFromContainer(animated: Bool = false, completion: (() -> Void)? = nil) {
        func remove() {
            willMove(toParent: nil)
            removeFromParent()
            view.removeFromSuperview()
        }
        if !animated {
            remove()
            completion?()
            return
        }
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.view.alpha = 0.0
            },
            completion: { _ in
                remove()
                completion?()
            }
        )
    }
}
