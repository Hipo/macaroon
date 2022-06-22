// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import UIKit

open class ToastUILayoutCalculator: ToastUILayoutCalculating {
    private var config: ToastUIConfiguration

    private unowned let presentingView: UIView

    public init(
        config: ToastUIConfiguration,
        presentingView: UIView
    ) {
        self.config = config
        self.presentingView = presentingView
    }

    open func calculateInitialFrame(
        ofNextPresented nextView: UIView
    ) -> CGRect {
        let maxSize = calculatingMaxSizeOfAnyPresented(nextView)
        let preferredSize = calculatePreferredSizeOfAnyPresented(
            nextView,
            fittingIn: maxSize
        )
        let originXOffset = ((maxSize.width - preferredSize.width) / 2).rounded()
        let originX = config.minContentHorizontalEdgeInsets.leading + originXOffset
        let originY = config.initialPresentingLayoutAttributes.offsetY
        return CGRect(
            origin: CGPoint(x: originX, y: originY),
            size: preferredSize
        )
    }

    open func calculateFinalFrame(
        ofNextPresented nextView: UIView
    ) -> CGRect {
        let initialFrame = calculateInitialFrameOfAnyPresented(nextView)
        let originX = initialFrame.minX
        let originYOffset = presentingView.safeAreaInsets.top
        let originY = originYOffset + config.finalPresentingLayoutAttributes.offsetY
        let size = initialFrame.size
        return CGRect(
            origin: CGPoint(x: originX, y: originY),
            size: size
        )
    }

    open func calculateFinalFrame(
        ofReplacingLastPresented lastView: UIView
    ) -> CGRect {
        let initialFrame = calculateInitialFrameOfAnyPresented(lastView)
        let originX = initialFrame.minX
        let originYOffset = presentingView.safeAreaInsets.top
        let originY = originYOffset + config.replacingLayoutAttributes.offsetY
        let size = initialFrame.size
        return CGRect(
            origin: CGPoint(x: originX, y: originY),
            size: size
        )
    }

    open func calculateFinalFrame(
        ofDismissingLastPresented lastView: UIView
    ) -> CGRect {
        let initialFrame = calculateInitialFrameOfAnyPresented(lastView)
        let originX = initialFrame.minX
        let originY = config.dismissingLayoutAttributes.offsetY
        let size = initialFrame.size
        return CGRect(
            origin: CGPoint(x: originX, y: originY),
            size: size
        )
    }

    public func calculateInitialFrameOfAnyPresented(
        _ anyView: UIView
    ) -> CGRect {
        return anyView.frame.isEmpty
            ? calculateInitialFrame(ofNextPresented: anyView)
            : anyView.frame
    }

    public func calculatingMaxSizeOfAnyPresented(
        _ anyView: UIView
    ) -> CGSize {
        let maxWidth =
            presentingView.bounds.width -
            config.minContentHorizontalEdgeInsets.leading -
            config.minContentHorizontalEdgeInsets.trailing
        let maxHeight =
            presentingView.bounds.height -
            config.finalPresentingLayoutAttributes.offsetY
        return CGSize(width: maxWidth, height: maxHeight)
    }

    public func calculatePreferredSizeOfAnyPresented(
        _ anyView: UIView,
        fittingIn maxSize: CGSize
    ) -> CGSize {
        return anyView.sizeThatFits(maxSize)
    }
}
