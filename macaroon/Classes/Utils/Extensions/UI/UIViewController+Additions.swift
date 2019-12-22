// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

/// <mark> Containers
extension UIViewController {
    public func fillToContainer(_ child: UIViewController) {
        add(child) { [unowned self] view in
            self.view.addSubview(view)
            view.snp.makeConstraints { maker in
                maker.top.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
        }
    }

    public func insertToContainer(_ child: UIViewController, below frontChild: UIViewController, insetBy padding: UIEdgeInsets) {
        add(child) { [unowned self] view in
            self.view.insertSubview(view, belowSubview: frontChild.view)
            view.snp.makeConstraints { maker in
                maker.top.equalToSuperview().inset(padding.top)
                maker.leading.equalToSuperview().inset(padding.left)
                maker.bottom.equalToSuperview().inset(padding.bottom)
                maker.trailing.equalToSuperview().inset(padding.right)
            }
        }
    }

    public func insertToContainer(_ child: UIViewController, above backChild: UIViewController, insetBy padding: UIEdgeInsets) {
        add(child) { [unowned self] view in
            self.view.insertSubview(view, aboveSubview: backChild.view)
            view.snp.makeConstraints { maker in
                maker.top.equalToSuperview().inset(padding.top)
                maker.leading.equalToSuperview().inset(padding.left)
                maker.bottom.equalToSuperview().inset(padding.bottom)
                maker.trailing.equalToSuperview().inset(padding.right)
            }
        }
    }

    public func add(_ child: UIViewController, with layout: (UIView) -> Void) {
        addChild(child)
        layout(child.view)
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
