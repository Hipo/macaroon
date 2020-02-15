// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public class ListEmptyView: UIView {
    public var state: State = .none {
        didSet {
            updateContentWhenStateChanged()
        }
    }

    public weak var dataSource: ListEmptyViewDataSource?

    private var currentContent: UIView?
}

extension ListEmptyView {
    public func updateContentWhenStateChanged() {
        removeCurrentContent()

        switch state {
        case .none:
            break
        case .loading:
            addLoadingIndicator()
        case .refreshing:
            break
        case .noContent:
            addNoContentView()
        case .noNetwork:
            addNoNetworkView()
        case .fault:
            addFaultView()
        }
    }

    public func removeCurrentContent() {
        if let loadingIndicator = currentContent as? LoadingIndicator {
            loadingIndicator.stopAnimating()
        }
        currentContent?.removeFromSuperview()
        currentContent = nil
    }
}

extension ListEmptyView {
    private func addLoadingIndicator() {
        if let loadingIndicator = dataSource?.loadingIndicator(in: self) {
            let adjustment = dataSource?.loadingIndicatorVerticalPositionAdjustment(in: self) ?? 50.0

            addSubview(loadingIndicator)
            loadingIndicator.snp.makeConstraints { maker in
                maker.centerX.equalToSuperview()
                maker.top.equalToSuperview().inset(adjustment)
            }
            loadingIndicator.startAnimating()

            currentContent = loadingIndicator
        }
    }

    private func addNoContentView() {
        if let noContentView = dataSource?.noContentView(in: self) {
            addSubview(noContentView)
            noContentView.snp.makeConstraints { maker in
                maker.top.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.trailing.equalToSuperview()
            }

            currentContent = noContentView
        }
    }

    private func addNoNetworkView() {
        if let noNetworkView = dataSource?.noNetworkView(in: self) {
            addSubview(noNetworkView)
            noNetworkView.snp.makeConstraints { maker in
                maker.top.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.trailing.equalToSuperview()
            }

            currentContent = noNetworkView
        }
    }

    private func addFaultView() {
        if let faultView = dataSource?.faultView(in: self) {
            addSubview(faultView)
            faultView.snp.makeConstraints { maker in
                maker.top.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.trailing.equalToSuperview()
            }

            currentContent = faultView
        }
    }
}

extension ListEmptyView {
    public enum State {
        case none
        case loading
        case refreshing /// <note> The state for pull-to-refresh
        case noContent
        case noNetwork
        case fault
    }
}

public protocol ListEmptyViewDataSource: AnyObject {
    func loadingIndicator(in view: ListEmptyView) -> LoadingIndicator?
    func loadingIndicatorVerticalPositionAdjustment(in view: ListEmptyView) -> CGFloat?
    func noContentView(in view: ListEmptyView) -> UIView?
    func noNetworkView(in view: ListEmptyView) -> UIView?
    func faultView(in view: ListEmptyView) -> UIView?
}

extension ListEmptyViewDataSource {
    public func loadingIndicator(in view: ListEmptyView) -> LoadingIndicator? {
        return nil
    }

    public func loadingIndicatorVerticalPositionAdjustment(in view: ListEmptyView) -> CGPoint? {
        return nil
    }

    public func noContentView(in view: ListEmptyView) -> UIView? {
        return nil
    }

    public func noNetworkView(in view: ListEmptyView) -> UIView? {
        return nil
    }

    public func faultView(in view: ListEmptyView) -> UIView? {
        return nil
    }
}
