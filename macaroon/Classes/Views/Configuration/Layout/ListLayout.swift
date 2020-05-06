// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ListLayout: AnyObject {
    var listView: UICollectionView? { get set }
    var scrollDirection: UICollectionView.ScrollDirection { get }
    var itemSize: ListItemSize { get }
    var headerSize: ListSupplementarySize { get }
    var footerSize: ListSupplementarySize { get }
    var minimumLineSpacing: ListSpacing { get }
    var minimumInteritemSpacing: ListSpacing { get }
    var sectionInset: ListSectionInset { get }
    var headersPinToVisibleBounds: Bool { get }
    var footersPinToVisibleBounds: Bool { get }

    func prepareForUse()
    func dequeueCell(for item: Any?, at indexPath: IndexPath) -> UICollectionViewCell
    func configure(_ cell: UICollectionViewCell, with item: Any?, at indexPath: IndexPath)
    func dequeueHeader(for item: Any?, in section: Int) -> UICollectionReusableView
    func configure(header: UICollectionReusableView, with item: Any?, in section: Int)
    func shouldShowHeadersForEmptySection(_ section: Int) -> Bool
    func dequeueFooter(for item: Any?, in section: Int) -> UICollectionReusableView
    func configure(footer: UICollectionReusableView, with item: Any?, in section: Int)
    func shouldShowFooterForEmptySection(_ section: Int) -> Bool
}

extension ListLayout {
    public var scrollDirection: UICollectionView.ScrollDirection {
        return .vertical
    }
    public var headerSize: ListSupplementarySize {
        return .fixed(.zero)
    }
    public var footerSize: ListSupplementarySize {
        return .fixed(.zero)
    }
    public var minimumLineSpacing: ListSpacing {
        return .fixed(0.0)
    }
    public var minimumInteritemSpacing: ListSpacing {
        return .fixed(0.0)
    }
    public var sectionInset: ListSectionInset {
        return .fixed(.zero)
    }
    public var headersPinToVisibleBounds: Bool {
        return true
    }
    public var footersPinToVisibleBounds: Bool {
        return true
    }

    // swiftlint:disable unavailable_function
    public func dequeueHeader(for item: Any?, in section: Int) -> UICollectionReusableView {
        mc_crash(.unsupportedListHeader(UICollectionReusableView.self))
    }
    // swiftlint:enable unavailable_function

    public func configure(header: UICollectionReusableView, with item: Any?, in section: Int) { }

    public func shouldShowHeadersForEmptySection(_ section: Int) -> Bool {
        return false
    }

    // swiftlint:disable unavailable_function
    public func dequeueFooter(for item: Any?, in section: Int) -> UICollectionReusableView {
        mc_crash(.unsupportedListFooter(UICollectionReusableView.self))
    }
    // swiftlint:enable unavailable_function

    public func configure(footer: UICollectionReusableView, with item: Any?, in section: Int) { }

    public func shouldShowFooterForEmptySection(_ section: Int) -> Bool {
        return false
    }
}

extension ListLayout {
    public var contentWidth: CGFloat {
        if let listView = listView {
            return listView.bounds.width - listView.contentInset.x
        }
        return UIScreen.main.bounds.width
    }
}

extension ListLayout {
    public func cell(for item: Any?, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueCell(for: item, at: indexPath)
        configure(cell, with: item, at: indexPath)
        return cell
    }

    public func header(for item: Any?, in section: Int) -> UICollectionReusableView {
        let header = dequeueHeader(for: item, in: section)
        configure(header: header, with: item, in: section)
        return header
    }

    public func footer(for item: Any?, in section: Int) -> UICollectionReusableView {
        let footer = dequeueFooter(for: item, in: section)
        configure(footer: footer, with: item, in: section)
        return footer
    }

    public func size(for item: Any?, at indexPath: IndexPath) -> CGSize {
        switch itemSize {
        case .fixed(let fixedSize):
            return fixedSize
        case .dynamic(let calculator):
            return calculator(item, indexPath)
        case .selfSizing:
            return CGSize(width: -1.0, height: -1.0)
        }
    }

    public func headerSize(for item: Any?, in section: Int) -> CGSize {
        switch headerSize {
        case .fixed(let fixedHeaderSize):
            return fixedHeaderSize
        case .dynamic(let calculator):
            return calculator(item, section)
        }
    }

    public func footerSize(for item: Any?, in section: Int) -> CGSize {
        switch footerSize {
        case .fixed(let fixedFooterSize):
            return fixedFooterSize
        case .dynamic(let calculator):
            return calculator(item, section)
        }
    }

    public func minimumLineSpacing(for item: Any?, in section: Int) -> CGFloat {
        switch minimumLineSpacing {
        case .fixed(let fixedMinimumLineSpacing):
            return fixedMinimumLineSpacing
        case .dynamic(let calculator):
            return calculator(item, section)
        }
    }

    public func minimumInteritemSpacing(for item: Any?, in section: Int) -> CGFloat {
        switch minimumInteritemSpacing {
        case .fixed(let fixedMinimumInteritemSpacing):
            return fixedMinimumInteritemSpacing
        case .dynamic(let calculator):
            return calculator(item, section)
        }
    }

    public func sectionInset(for item: Any?, in section: Int) -> UIEdgeInsets {
        switch sectionInset {
        case .fixed(let fixedSectionInset):
            return fixedSectionInset
        case .dynamic(let calculator):
            return calculator(item, section)
        }
    }
}

extension ListLayout {
    public func reloadHeader(with item: Any?, in section: Int, forceInvalidation: Bool = false, animated: Bool = false) {
        if let visibleHeader = listView?.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)) {
            configure(header: visibleHeader, with: item, in: section)

            if forceInvalidation {
                invalidateHeader(in: section, animated: animated)
            }
        } else {
            invalidateHeader(in: section, animated: animated)
        }
    }
}

extension ListLayout {
    public func invalidate(_ context: UICollectionViewFlowLayoutInvalidationContext? = nil, forceLayoutUpdate: Bool = false) {
        if let context = context {
            _layout.invalidateLayout(with: context)
        } else {
            _layout.invalidateLayout()
        }
        if forceLayoutUpdate {
            listView?.layoutIfNeeded()
        }
    }

    public func invalidateHeader(in section: Int, animated: Bool = false) {
        let context = UICollectionViewFlowLayoutInvalidationContext()
        context.invalidateFlowLayoutDelegateMetrics = true
        context.invalidateSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader, at: [IndexPath(item: 0, section: section)])

        let completeInvalidation = {
            self.listView?.performBatchUpdates({ [weak self] in self?.invalidate(context) }, completion: nil)
        }

        if !animated {
            completeInvalidation()
            return
        }
        let animator = UIViewPropertyAnimator(duration: 0.33, dampingRatio: 0.5) {
            completeInvalidation()
        }
        animator.startAnimation()
    }
}

extension ListLayout {
    var _layout: UICollectionViewFlowLayout {
        guard let listView = listView else {
            return formFlowLayout()
        }
        guard let flowLayout = listView.collectionViewLayout as? UICollectionViewFlowLayout else {
            mc_crash(.unsupportedListLayout)
        }
        return flowLayout
    }

    private func formFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = scrollDirection
        flowLayout.sectionHeadersPinToVisibleBounds = headersPinToVisibleBounds
        flowLayout.sectionFootersPinToVisibleBounds = footersPinToVisibleBounds
        setItemSize(flowLayout)
        return flowLayout
    }

    private func setItemSize(_ flowLayout: UICollectionViewFlowLayout) {
        switch itemSize {
        case .fixed(let fixedItemSize):
            flowLayout.estimatedItemSize = .zero
            flowLayout.itemSize = fixedItemSize
        case .dynamic:
            flowLayout.estimatedItemSize = .zero
        case .selfSizing:
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
}

public enum ListItemSize {
    public typealias SizeCalculator = (Any?, IndexPath) -> CGSize

    case fixed(CGSize)
    case dynamic(SizeCalculator)
    case selfSizing /// <warning> Not implemented. It can cause some issues.
}

public enum ListSupplementarySize {
    public typealias SizeCalculator = (Any?, Int) -> CGSize

    case fixed(CGSize)
    case dynamic(SizeCalculator)
}

public enum ListSpacing {
    public typealias SpacingCalculator = (Any?, Int) -> CGFloat

    case fixed(CGFloat)
    case dynamic(SpacingCalculator)
}

public enum ListSectionInset {
    public typealias InsetCalculator = (Any?, Int) -> UIEdgeInsets

    case fixed(UIEdgeInsets)
    case dynamic(InsetCalculator)
}

extension UICollectionView {
    public convenience init(listLayout: ListLayout) {
        self.init(frame: .zero, collectionViewLayout: listLayout._layout)
        listLayout.listView = self
    }
}
