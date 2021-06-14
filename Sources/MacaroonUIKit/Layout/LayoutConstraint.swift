// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import SnapKit
import UIKit

public struct LayoutConstraint {
    public let target: Target
    public let multiplier: LayoutMetric?
    public let constant: LayoutMetric?
    public let priority: UILayoutPriority?

    public var isRelational: Bool {
        switch target {
        case .superview: return false
        default: return true
        }
    }

    init(
        target: Target = .superview,
        multiplier: LayoutMetric? = nil,
        constant: LayoutMetric? = nil,
        priority: UILayoutPriority? = nil
    ) {
        self.target = target
        self.multiplier = multiplier
        self.constant = constant
        self.priority = priority
    }

    init(
        constraintItem: ConstraintItem? = nil,
        multiplier: LayoutMetric? = nil,
        constant: LayoutMetric? = nil,
        priority: UILayoutPriority? = nil
    ) {
        self.init(
            target: Target(constraintItem: constraintItem),
            multiplier: multiplier,
            constant: constant,
            priority: priority
        )
    }

    init(
        view: UIView? = nil,
        multiplier: LayoutMetric? = nil,
        constant: LayoutMetric? = nil,
        priority: UILayoutPriority? = nil
    ) {
        self.init(
            target: Target(view: view),
            multiplier: multiplier,
            constant: constant,
            priority: priority
        )
    }
}

extension LayoutConstraint {
    public enum Target {
        case superview
        case view(UIView)
        case constraintItem(ConstraintItem)

        init(
            view: UIView?
        ) {
            switch view {
            case .some(let someView): self = .view(someView)
            case .none: self = .superview
            }
        }

        init(
            constraintItem: ConstraintItem?
        ) {
            switch constraintItem {
            case .some(let someConstraintItem): self = .constraintItem(someConstraintItem)
            case .none: self = .superview
            }
        }
    }
}
