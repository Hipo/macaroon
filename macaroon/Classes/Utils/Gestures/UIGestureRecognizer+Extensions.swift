//
//  UIGestureRecognizer+Extensions.swift
//  Macaroon
//
//  Created by Salih Karasuluoglu on 10.03.2021.
//

import Foundation
import UIKit

extension UIPanGestureRecognizer {
    public func initialVelocityForSpringAnimation(
        forDistance distance: CGPoint,
        in view: UIView?
    ) -> CGVector {
        var animationVelocity: CGVector = .zero
        let gestureVelocity =
            velocity(
                in: view
            )

        if distance.x != 0 {
            animationVelocity.dx = gestureVelocity.x / distance.x
        }

        if distance.y != 0 {
            animationVelocity.dy = gestureVelocity.y / distance.y
        }

        return animationVelocity
    }

    public func rubberBandTranslation(
        forDifference diff: CGFloat,
        dimmingAt dim: CGFloat
    ) -> CGFloat {
        return (1.0 - (1.0 / ((diff * 0.55 / dim) + 1.0))) * dim
    }
}
