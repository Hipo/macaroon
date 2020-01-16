// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ListView: UICollectionView {
    public var emptyState: ListEmptyView.State {
        get {
            return emptyView.state
        }
        set {
            if emptyView.state == .refreshing {
                if newValue != .loading { /// <note> Don't show loading if the pull-to-refresh is triggerred.
                    emptyView.state = newValue
                }
            } else {
                emptyView.state = newValue
            }
        }
    }

    public weak var emptyStateDataSource: ListEmptyViewDataSource? {
        get {
            return emptyView.dataSource
        }
        set {
            emptyView.dataSource = newValue
        }
    }

    private lazy var emptyView = ListEmptyView()

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
        addEmptyView()
    }

    private func updateLayoutWhenViewDidLayoutSubviews() {
        updateEmptyViewLayoutWhenViewDidLayoutSubviews()
    }

    private func addEmptyView() {
        backgroundView = emptyView
    }

    private func updateEmptyViewLayoutWhenViewDidLayoutSubviews() {
        emptyView.frame = bounds
    }
}
