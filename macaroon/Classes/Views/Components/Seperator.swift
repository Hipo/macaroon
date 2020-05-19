// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public struct Seperator {
    public let style: Styling
    public let size: CGFloat /// <note> It means width if the seperator is vertical and height if the seperator is horizontal.
    public let insets: (CGFloat, CGFloat) /// <note> It means top&bottom if the seperator is vertical and left&right if the seperator is vertical.

    public init(
        style: Styling,
        size: CGFloat = 1.0,
        insets: (CGFloat, CGFloat) = (0.0, 0.0)
    ) {
        self.style = style
        self.size = size
        self.insets = insets
    }
}

public enum SeperatorPosition {
    case top
    case left
    case bottom
    case right
}

extension UIView {
    /// <note> `padding` indicates the distance between seperator and the edge.
    @discardableResult
    public func addSeperator(_ seperator: Seperator, at position: SeperatorPosition, padding: CGFloat = 0.0) -> UIView {
        let view = makeView(for: seperator)

        addSubview(view)
        view.snp.makeConstraints { maker in
            switch position {
            case .top:
                maker.top.equalToSuperview().inset(padding)
            case .left:
                maker.leading.equalToSuperview().inset(padding)
            case .bottom:
                maker.bottom.equalToSuperview().inset(padding)
            case .right:
                maker.trailing.equalToSuperview().inset(padding)
            }
            makeAdjustments(maker, for: seperator, at: position)
        }

        return view
    }

    /// <note> `padding` indicates the distance between seperator and aView's edge.
    @discardableResult
    public func attachSeperator(_ seperator: Seperator, to aView: UIView, at position: SeperatorPosition, margin: CGFloat = 0.0) -> UIView {
        let view = makeView(for: seperator)

        addSubview(view)
        view.snp.makeConstraints { maker in
            switch position {
            case .top:
                maker.bottom.equalTo(aView.snp.top).offset(-margin)
            case .left:
                maker.trailing.equalTo(aView.snp.leading).offset(-margin)
            case .bottom:
                maker.top.equalTo(aView.snp.bottom).offset(margin)
            case .right:
                maker.leading.equalTo(aView.snp.trailing).offset(margin)
            }
            makeAdjustments(maker, for: seperator, at: position)
        }

        return view
    }
}

extension UIView {
    func makeView(for seperator: Seperator) -> UIView {
        let view = BaseView()
        view.customizeBaseAppearance(seperator.style)
        return view
    }

    func makeAdjustments(_ maker: ConstraintMaker, for seperator: Seperator, at position: SeperatorPosition) {
        switch position {
        case .top,
            .bottom:
            maker.height.equalTo(seperator.size)
            maker.leading.equalToSuperview().inset(seperator.insets.0)
            maker.trailing.equalToSuperview().inset(seperator.insets.1)
        case .left,
             .right:
            maker.width.equalTo(seperator.size)
            maker.top.equalToSuperview().inset(seperator.insets.0)
            maker.bottom.equalToSuperview().inset(seperator.insets.1)
        }
    }
}
