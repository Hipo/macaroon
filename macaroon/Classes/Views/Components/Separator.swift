// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public struct Separator {
    public let style: Styling
    public let size: CGFloat /// <note> It means width if the separator is vertical and height if the separator is horizontal.
    public let insets: (CGFloat, CGFloat) /// <note> It means top&bottom if the separator is vertical and left&right if the separator is vertical.

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

public enum SeparatorPosition {
    case top
    case left
    case bottom
    case right
}

extension UIView {
    /// <note> `padding` indicates the distance between separator and the edge.
    @discardableResult
    public func addSeparator(_ separator: Separator, at position: SeparatorPosition, padding: CGFloat = 0.0) -> UIView {
        let view = makeView(for: separator)

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
            makeAdjustments(maker, for: separator, at: position)
        }

        return view
    }

    /// <note> `padding` indicates the distance between separator and aView's edge.
    @discardableResult
    public func attachSeparator(_ separator: Separator, to aView: UIView, at position: SeparatorPosition, margin: CGFloat = 0.0) -> UIView {
        let view = makeView(for: separator)

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
            makeAdjustments(maker, for: separator, at: position)
        }

        return view
    }
}

extension UIView {
    func makeView(for separator: Separator) -> UIView {
        let view = BaseView()
        view.customizeBaseAppearance(separator.style)
        return view
    }

    func makeAdjustments(_ maker: ConstraintMaker, for separator: Separator, at position: SeparatorPosition) {
        switch position {
        case .top,
            .bottom:
            maker.height.equalTo(separator.size)
            maker.leading.equalToSuperview().inset(separator.insets.0)
            maker.trailing.equalToSuperview().inset(separator.insets.1)
        case .left,
             .right:
            maker.width.equalTo(separator.size)
            maker.top.equalToSuperview().inset(separator.insets.0)
            maker.bottom.equalToSuperview().inset(separator.insets.1)
        }
    }
}
