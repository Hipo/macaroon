// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

extension ConstraintMaker {
    public typealias SizeConstraints =
        (
            width: Constraint?,
            height: Constraint?
        )

    public typealias PaddingConstraints =
        (
            top: Constraint?,
            leading: Constraint?,
            bottom: Constraint?,
            trailing: Constraint?
        )

    public typealias HorizontalPaddingConstraints =
        (
            leading: Constraint?,
            trailing: Constraint?
        )

    public typealias VerticalPaddingConstraints =
        (
            top: Constraint?,
            bottom: Constraint?
        )

    public typealias CenterConstraints =
        (
            x: Constraint?,
            y: Constraint?
        )
}

extension ConstraintMaker {
    @discardableResult
    public func fitToSize(
        _ size: LayoutSize
    ) -> SizeConstraints {
        return fitToSize(
            (
                (size.w, .required),
                (size.h, .required)
            )
        )
    }

    @discardableResult
    public func fitToSize(
        _ size: PrioritizedLayoutSize
    ) -> SizeConstraints {
        var widthConstraint: Constraint?
        var heightConstraint: Constraint?

        if !size.w.metric.isNoConstraint {
            widthConstraint =
                width
                .equalTo(size.w.metric)
                .priority(size.w.priority)
                .constraint
        }

        if !size.h.metric.isNoConstraint {
            heightConstraint =
                height
                .equalTo(size.h.metric)
                .priority(size.h.priority)
                .constraint
        }

        return (widthConstraint, heightConstraint)
    }
}

extension ConstraintMaker {
    @discardableResult
    public func setPaddings(
        _ paddings: LayoutPaddings
    ) -> PaddingConstraints {
        return setPaddings(
            (
                (paddings.top, .required),
                (paddings.leading, .required),
                (paddings.bottom, .required),
                (paddings.trailing, .required)
            )
        )
    }

    @discardableResult
    public func setPaddings(
        _ paddings: PrioritizedLayoutPaddings
    ) -> PaddingConstraints {
        var topConstraint: Constraint?
        var leadingConstraint: Constraint?
        var bottomConstraint: Constraint?
        var trailingConstraint: Constraint?

        if !paddings.top.metric.isNoConstraint {
            topConstraint =
                top
                .equalToSuperview()
                .inset(
                    paddings.top.metric
                )
                .priority(paddings.top.priority)
                .constraint
        }

        if !paddings.leading.metric.isNoConstraint {
            leadingConstraint =
                leading
                .equalToSuperview()
                .inset(
                    paddings.leading.metric
                )
                .priority(paddings.leading.priority)
                .constraint
        }

        if !paddings.bottom.metric.isNoConstraint {
            bottomConstraint =
                bottom
                .equalToSuperview()
                .inset(
                    paddings.bottom.metric
                )
                .priority(paddings.bottom.priority)
                .constraint
        }

        if !paddings.trailing.metric.isNoConstraint {
            trailingConstraint =
                trailing
                .equalToSuperview()
                .inset(
                    paddings.trailing.metric
                )
                .priority(paddings.trailing.priority)
                .constraint
        }

        return (topConstraint, leadingConstraint, bottomConstraint, trailingConstraint)
    }
}

extension ConstraintMaker {
    @discardableResult
    public func center(
        offset: LayoutOffset
    ) -> CenterConstraints {
        return center(
            offset: (
                (offset.x, .required),
                (offset.y, .required)
            )
        )
    }

    @discardableResult
    public func center(
        offset: PrioritizedLayoutOffset
    ) -> CenterConstraints {
        var xConstraint: Constraint?
        var yConstraint: Constraint?

        if !offset.x.metric.isNoConstraint {
            xConstraint =
                centerX
                .equalToSuperview()
                .offset(offset.x.metric)
                .priority(offset.x.priority)
                .constraint
        }

        if !offset.y.metric.isNoConstraint {
            xConstraint =
                centerY
                .equalToSuperview()
                .offset(offset.y.metric)
                .priority(offset.y.priority)
                .constraint
        }

        return (xConstraint, yConstraint)
    }

    @discardableResult
    public func centerHorizontally(
        offset: LayoutMetric,
        verticalPaddings: LayoutVerticalPaddings
    ) -> (offset: Constraint, verticalPaddings: VerticalPaddingConstraints) {
        return centerHorizontally(
            offset: (offset, .required),
            verticalPaddings: (
                (verticalPaddings.top, .required),
                (verticalPaddings.bottom, .required)
            )
        )
    }

    @discardableResult
    public func centerHorizontally(
        offset: PrioritizedLayoutMetric,
        verticalPaddings: PrioritizedLayoutVerticalPaddings
    ) -> (offset: Constraint, verticalPaddings: VerticalPaddingConstraints) {
        if offset.metric.isNoConstraint {
            mc_crash(
                .layoutConstraintCorrupted(reason: "This method expect an offset")
            )
        }

        let offsetConstraint =
            centerX
            .equalToSuperview()
            .offset(offset.metric)
            .priority(offset.priority)
            .constraint

        var topConstraint: Constraint?
        var bottomConstraint: Constraint?

        if !verticalPaddings.top.metric.isNoConstraint {
            topConstraint =
                top
                .equalToSuperview()
                .inset(verticalPaddings.top.metric)
                .priority(verticalPaddings.top.priority)
                .constraint
        }

        if !verticalPaddings.bottom.metric.isNoConstraint {
            bottomConstraint =
                bottom
                .equalToSuperview()
                .inset(verticalPaddings.bottom.metric)
                .priority(verticalPaddings.bottom.priority)
                .constraint
        }

        return (offsetConstraint, (topConstraint, bottomConstraint))
    }

    @discardableResult
    public func centerVertically(
        offset: LayoutMetric,
        horizontalPaddings: LayoutHorizontalPaddings
    ) -> (offset: Constraint, horizontalPaddings: HorizontalPaddingConstraints) {
        return centerVertically(
            offset: (offset, .required),
            horizontalPaddings: (
                (horizontalPaddings.leading, .required),
                (horizontalPaddings.trailing, .required)
            )
        )
    }

    @discardableResult
    public func centerVertically(
        offset: PrioritizedLayoutMetric,
        horizontalPaddings: PrioritizedLayoutHorizontalPaddings
    ) -> (offset: Constraint, horizontalPaddings: HorizontalPaddingConstraints) {
        if offset.metric.isNoConstraint {
            mc_crash(
                .layoutConstraintCorrupted(reason: "This method expect an offset")
            )
        }

        let offsetConstraint =
            centerX
            .equalToSuperview()
            .offset(offset.metric)
            .priority(offset.priority)
            .constraint

        var leadingConstraint: Constraint?
        var trailingConstraint: Constraint?

        if !horizontalPaddings.leading.metric.isNoConstraint {
            leadingConstraint =
                top
                .equalToSuperview()
                .inset(horizontalPaddings.leading.metric)
                .priority(horizontalPaddings.leading.priority)
                .constraint
        }

        if !horizontalPaddings.trailing.metric.isNoConstraint {
            trailingConstraint =
                bottom
                .equalToSuperview()
                .inset(horizontalPaddings.trailing.metric)
                .priority(horizontalPaddings.trailing.priority)
                .constraint
        }

        return (offsetConstraint, (leadingConstraint, trailingConstraint))
    }
}
