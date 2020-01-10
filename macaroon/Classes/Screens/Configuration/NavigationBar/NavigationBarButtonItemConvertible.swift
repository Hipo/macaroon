// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol NavigationBarButtonItemConvertible {
    typealias InteractionHandler = () -> Void

    var style: ButtonStyling { get }
    var size: BarButtonSize { get }
    var handler: InteractionHandler { get }

    func asSystemBarButtonItem() -> UIBarButtonItem
}

public enum BarButtonSize {
    case compressed(CompressedSizeMetric)
    case expanded(width: ExpandedWidthMetric, height: ExpandedHeightMetric)
    case aligned(AlignedContentSizeMetric)
    case explicit(CGSize)
}

extension BarButtonSize {
    public struct CompressedSizeMetric {
        public let content: UIEdgeInsets
        public let title: UIEdgeInsets?
        public let image: UIEdgeInsets?

        public init(
            content: UIEdgeInsets = .zero,
            title: UIEdgeInsets? = nil,
            image: UIEdgeInsets? = nil
        ) {
            self.content = content
            self.title = title
            self.image = image
        }
    }
}

extension BarButtonSize {
    public enum ExpandedWidthMetric {
        case equal(CGFloat)
        case insets(HorizontalInsets)
    }

    public enum ExpandedHeightMetric {
        case equal(CGFloat)
        case insets(VerticalInsets)
    }
}

extension BarButtonSize.ExpandedWidthMetric {
    public struct HorizontalInsets {
        public typealias Insets = (left: CGFloat, right: CGFloat)

        public let content: Insets
        public let title: Insets?
        public let image: Insets?

        public init(
            content: Insets = (0.0, 0.0),
            title: Insets? = nil,
            image: Insets? = nil
        ) {
            self.content = content
            self.title = title
            self.image = image
        }
    }
}

extension BarButtonSize.ExpandedHeightMetric {
    public struct VerticalInsets {
        public typealias Insets = (top: CGFloat, bottom: CGFloat)

        public let content: Insets
        public let title: Insets?
        public let image: Insets?

        public init(
            content: Insets = (0.0, 0.0),
            title: Insets? = nil,
            image: Insets? = nil
        ) {
            self.content = content
            self.title = title
            self.image = image
        }
    }
}

extension BarButtonSize {
    public struct AlignedContentSizeMetric {
        public enum Alignment {
            case top, left, bottom, right
        }

        public let explicitSize: CGSize
        public let alignment: Alignment
        public let insets: UIEdgeInsets

        public init(
            explicitSize: CGSize,
            alignment: Alignment = .left,
            insets: UIEdgeInsets = .zero
        ) {
            self.explicitSize = explicitSize
            self.alignment = alignment
            self.insets = insets
        }
    }
}
