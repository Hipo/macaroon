// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol NavigationBarButtonItemConvertible {
    associatedtype Styling
    typealias InteractionHandler = () -> Void

    var style: Styling { get }
    var size: BarButtonSize { get }
    var handler: InteractionHandler { get }

    func asSystemBarButtonItem() -> UIBarButtonItem

    static func pop(_ handler: @escaping InteractionHandler) -> Self?
    static func dismiss(_ handler: @escaping InteractionHandler) -> Self?
}

extension NavigationBarButtonItemConvertible {
    public var size: BarButtonSize {
        return .explicit(CGSize(width: 30.0, height: 30.0))
    }

    public static func pop(_ handler: @escaping InteractionHandler) -> Self? {
        return nil
    }

    public static func dismiss(_ handler: @escaping InteractionHandler) -> Self? {
        return nil
    }
}

public enum BarButtonSize {
    case compressed(CompressedSizeInsets)
    case expanded(width: ExpandedSizeMetric, height: ExpandedSizeMetric)
    case aligned(AlignedContentSize)
    case explicit(CGSize)
}

extension BarButtonSize {
    public struct CompressedSizeInsets {
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
    public enum ExpandedSizeMetric {
        case equal(CGFloat)
        /// DynamicDimension refers to width, parameters reflect left&right insets,
        /// likewise it refers to height, parameters reflect top&bottom insets.
        case dynamicWidth(HorizontalInsets)
        case dynamicHeight(VerticalInsets)
    }
}

extension BarButtonSize.ExpandedSizeMetric {
    public struct HorizontalInsets {
        public typealias Insets = (left: CGFloat, right: CGFloat)

        public let content: Insets
        public let title: Insets?
        public let image: Insets?

        public init(
            content: Insets,
            title: Insets? = nil,
            image: Insets? = nil
        ) {
            self.content = content
            self.title = title
            self.image = image
        }
    }

    public struct VerticalInsets {
        public typealias Insets = (top: CGFloat, bottom: CGFloat)

        public let content: Insets
        public let title: Insets?
        public let image: Insets?

        public init(
            content: Insets,
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
    public struct AlignedContentSize {
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

extension BarButtonSize.AlignedContentSize {
    public enum Alignment {
        case top
        case left
        case bottom
        case right
    }
}
