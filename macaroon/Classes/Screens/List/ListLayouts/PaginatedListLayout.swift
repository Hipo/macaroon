// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class PaginatedListLayout: UICollectionViewFlowLayout {
    open func horizontalTargetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }

        let collectionViewSize = collectionView.bounds.size
        let centerXOffset = collectionViewSize.width / 2.0
        let expectedCenterX = proposedContentOffset.x + centerXOffset
        let targetRect = CGRect(
            x: proposedContentOffset.x + collectionViewSize.width * 0.25,
            y: proposedContentOffset.y,
            width: collectionViewSize.width * 0.5,
            height: collectionViewSize.height
        )
        let layoutAttributes =
            layoutAttributesForElements(
                in: targetRect
            )
        let closestLayoutAttribute =
            layoutAttributes?
                .min {
                    if $0.representedElementCategory != .cell {
                        return false
                    }

                    return abs($0.center.x - expectedCenterX) < abs($1.center.x - expectedCenterX)
                }

        return closestLayoutAttribute.unwrap(
            {
                CGPoint(x: $0.center.x - centerXOffset, y: proposedContentOffset.y)
            },
            or: proposedContentOffset
        )
    }

    open func verticalTargetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }

        let collectionViewSize = collectionView.bounds.size
        let centerYOffset = collectionViewSize.height / 2.0
        let expectedCenterY = proposedContentOffset.y + centerYOffset
        let targetRect = CGRect(
            x: proposedContentOffset.x,
            y: proposedContentOffset.y + collectionViewSize.height * 0.25,
            width: collectionViewSize.width,
            height: collectionViewSize.height * collectionViewSize.height * 0.5
        )
        let layoutAttributes =
            layoutAttributesForElements(
                in: targetRect
            )
        let closestLayoutAttribute =
            layoutAttributes?
                .min {
                    if $0.representedElementCategory != .cell {
                        return false
                    }

                    return abs($0.center.y - expectedCenterY) < abs($1.center.y - expectedCenterY)
                }
        return closestLayoutAttribute.unwrap(
            {
                CGPoint(x: proposedContentOffset.x, y: $0.center.y - centerYOffset)
            },
            or: proposedContentOffset
        )
    }

    open override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        switch scrollDirection {
        case .horizontal:
            return horizontalTargetContentOffset(
                forProposedContentOffset: proposedContentOffset,
                withScrollingVelocity: velocity
            )
        case .vertical:
            return verticalTargetContentOffset(
                forProposedContentOffset: proposedContentOffset,
                withScrollingVelocity: velocity
            )
        @unknown default:
            return proposedContentOffset
        }
    }
}
