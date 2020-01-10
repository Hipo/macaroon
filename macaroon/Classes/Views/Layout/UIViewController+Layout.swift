// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

extension UIViewController {
    @discardableResult
    public func fitInContent(_ content: UIViewController, insetBy margins: UIEdgeInsets = .zero) -> UIViewController {
        return addContent(content) { contentView in
            view.addSubview(contentView)
            contentView.fitToSuperview(insetBy: margins)
        }
    }

    @discardableResult
    public func insertContent(_ content: UIViewController, below frontContent: UIViewController, prepareLayout: (UIView) -> Void) -> UIViewController {
        return addContent(content) { contentView in
            view.insertSubview(contentView, belowSubview: frontContent.view)
            prepareLayout(contentView)
        }
    }

    @discardableResult
    public func insertContent(_ content: UIViewController, above backContent: UIViewController, prepareLayout: (UIView) -> Void) -> UIViewController {
        return addContent(content) { contentView in
            view.insertSubview(contentView, aboveSubview: backContent.view)
            prepareLayout(contentView)
        }
    }

    @discardableResult
    public func addContent(_ content: UIViewController, prepareLayout: (UIView) -> Void) -> UIViewController {
        addChild(content)
        prepareLayout(content.view)
        content.didMove(toParent: self)
        return content
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
