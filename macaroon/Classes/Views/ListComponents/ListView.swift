// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ListView: UICollectionView, EmptyStatePresentable {
    public private(set) lazy var emptyStateView = EmptyStateView()

    public override init(
        frame: CGRect,
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        super.init(
            frame: frame,
            collectionViewLayout: layout
        )
        customizeAppearance()
        prepareLayout()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLayoutWhenViewDidLayoutSubviews()
    }
}

extension ListView {
    private func customizeAppearance() {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            switch flowLayout.scrollDirection {
            case .horizontal:
                alwaysBounceHorizontal = true
            case .vertical:
                alwaysBounceVertical = true
            @unknown default:
                break
            }
        }
        reorderingCadence = .fast
    }
}

extension ListView {
    private func prepareLayout() {
        addEmptyState()
    }

    private func updateLayoutWhenViewDidLayoutSubviews() {
        emptyStateView.frame = bounds
    }
}
