// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ToastUIAnimationControlling: AnyObject {
    func prepareForAnimation(
        presented viewToPresent: UIView
    )

    func makePresentingAnimator(
        forNextPresented nextView: UIView
    ) -> UIViewPropertyAnimator
    func makePresentingAnimator(
        forNextPresented nextView: UIView,
        replacingLastPresented lastView: UIView
    ) -> UIViewPropertyAnimator
    func makeDismissingAnimator(
        forLastPresented lastView: UIView
    ) -> UIViewPropertyAnimator
}
