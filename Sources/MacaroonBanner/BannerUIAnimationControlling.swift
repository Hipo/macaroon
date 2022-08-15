// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol BannerUIAnimationControlling: AnyObject {
    func makePresentingAnimator(
        forNextPresented nextView: UIView
    ) -> UIViewPropertyAnimator
    func makeDismissingAnimator(
        forLastPresented lastView: UIView
    ) -> UIViewPropertyAnimator
}
