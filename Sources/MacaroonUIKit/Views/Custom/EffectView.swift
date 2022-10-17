// Copyright © 2019 hipolabs. All rights reserved.

import UIKit
import SnapKit

open class EffectView: UIView {
    public var effect: Effect? {
        didSet { reloadEffect() }
    }

    private var contentView: UIView?
}

extension EffectView {
    public func setEffectHidden(_ hidden: Bool) {
        contentView?.isHidden = hidden
    }
}

extension EffectView {
    private func reloadEffect() {
        removeOldEffect()
        addNewEffect()
    }

    private func addNewEffect() {
        guard let effect = effect else { return }

        let newContentView = effect.makeView()

        insertSubview(
            newContentView,
            at: 0
        )
        newContentView.snp.makeConstraints {
            $0.top == 0
            $0.leading == 0
            $0.bottom == 0
            $0.trailing == 0
        }
    }

    private func removeOldEffect() {
        contentView?.removeFromSuperview()
        contentView = nil
    }
}

public protocol Effect {
    func makeView() -> UIView
}

public struct BlurEffect: Effect {
    public typealias Style = UIBlurEffect.Style

    let style: Style

    public init(style: Style) {
        self.style = style
    }

    public func makeView() -> UIView {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: style)
        return view
    }
}

public struct LinearGradientEffect: Effect {
    let gradient: Gradient

    public init(gradient: Gradient) {
        self.gradient = gradient
    }

    public func makeView() -> UIView {
        let view = GradientView()
        view.draw(gradient: gradient)
        return view
    }
}
