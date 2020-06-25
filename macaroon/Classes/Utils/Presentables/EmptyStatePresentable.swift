// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public protocol EmptyStatePresentable: AnyObject {
    var emptyState: EmptyStateView.State { get set }
    var emptyStateView: EmptyStateView { get }

    func addEmptyState()
    func updateEmptyState(_ newEmptyState: EmptyStateView.State)
    func removeEmptyState()
}

extension EmptyStatePresentable {
    public var emptyState: EmptyStateView.State {
        get { emptyStateView.state }
        set { updateEmptyState(newValue) }
    }

    public func updateEmptyState(_ newEmptyState: EmptyStateView.State) {
        emptyStateView.state = newEmptyState
    }
}

extension EmptyStatePresentable {
    public var emptyStateDataSource: EmptyStateViewDataSource? {
        get { emptyStateView.dataSource }
        set { emptyStateView.dataSource = newValue }
    }
}

extension EmptyStatePresentable where Self: UIView {
    public func addEmptyState() {
        if emptyStateView.isDescendant(of: self) { return }

        addSubview(emptyStateView)
        emptyStateView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }

    public func updateEmptyState(_ newEmptyState: EmptyStateView.State) {
        switch newEmptyState {
        case .none:
            removeEmptyState()
            emptyStateView.state = newEmptyState
        default:
            addEmptyState()
            emptyStateView.state = newEmptyState
        }
    }

    public func removeEmptyState() {
        emptyStateView.removeFromSuperview()
    }
}

extension EmptyStatePresentable where Self: UICollectionView {
    public func addEmptyState() {
        backgroundView = emptyStateView

        if !bounds.isEmpty {
            backgroundView?.frame = bounds
        }
    }

    public func removeEmptyState() {
        backgroundView = nil
    }
}

extension EmptyStatePresentable where Self: UIViewController {
    public func addEmptyState() {
        if emptyStateView.isDescendant(of: self.view) { return }

        view.addSubview(emptyStateView)
        emptyStateView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }

    public func updateEmptyState(_ newEmptyState: EmptyStateView.State) {
        switch newEmptyState {
        case .none:
            removeEmptyState()
            emptyStateView.state = newEmptyState
        default:
            addEmptyState()
            emptyStateView.state = newEmptyState
        }
    }

    public func removeEmptyState() {
        emptyStateView.removeFromSuperview()
    }
}
