// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public class EmptyStateView: UIView {
    internal(set) public var state: State = .none {
        didSet { stateDidChange() }
    }
    public var showsLoadingOnRefreshing = false

    public weak var dataSource: EmptyStateViewDataSource?

    private var currentContentView: UIView?
}

extension EmptyStateView {
    private func stateDidChange() {
        updateContentWhenStateDidChange()
    }
}

extension EmptyStateView {
    private func updateContentWhenStateDidChange() {
        removeCurrentContent()

        switch state {
        case .none:
            break
        case .loading:
            addLoading()
        case .refreshing:
            if showsLoadingOnRefreshing {
                addLoading()
            }
        case .noContent(let userInfo):
            addNoContent(userInfo: userInfo)
        case .noNetwork(let userInfo):
            addNoNetwork(userInfo: userInfo)
        case .fault(let userInfo):
            addFault(userInfo: userInfo)
        }
    }

    public func removeCurrentContent() {
        if let loadingIndicator = currentContentView as? LoadingIndicator {
            loadingIndicator.stopAnimating()
        }
        currentContentView?.removeFromSuperview()
        currentContentView = nil
    }

    private func addLoading() {
        if let loadingIndicator = dataSource?.loadingIndicator(in: self) {
            let contentEdgeInsets = dataSource?.contentEdgeInsets(in: self)

            addSubview(loadingIndicator)
            loadingIndicator.snp.makeConstraints { maker in
                maker.centerX.equalToSuperview()
                maker.top.equalToSuperview().inset(contentEdgeInsets?.top ?? 40.0)
            }

            loadingIndicator.startAnimating()

            currentContentView = loadingIndicator
        }
    }

    private func addNoContent(userInfo: Any?) {
        dataSource?.noContentView(userInfo: userInfo, in: self).executeIfPresent(addCustomContent)
    }

    private func addNoNetwork(userInfo: Any?) {
        dataSource?.noNetworkView(userInfo: userInfo, in: self).executeIfPresent(addCustomContent)
    }

    private func addFault(userInfo: Any?) {
        dataSource?.faultView(userInfo: userInfo, in: self).executeIfPresent(addCustomContent)
    }

    private func addCustomContent(_ contentView: UIView) {
        let contentEdgeInsets = dataSource?.contentEdgeInsets(in: self)

        addSubview(contentView)
        contentView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(contentEdgeInsets?.top ?? 0.0)
            maker.leading.equalToSuperview().inset(contentEdgeInsets?.left ?? 0.0)
            maker.trailing.equalToSuperview().inset(contentEdgeInsets?.right ?? 0.0)

            if let bottomInset = contentEdgeInsets?.bottom {
                maker.bottom.greaterThanOrEqualToSuperview().inset(bottomInset)
            } else {
                maker.bottom.equalToSuperview()
            }
        }

        currentContentView = contentView
    }
}

extension EmptyStateView {
    public enum State {
        case none
        case loading
        case refreshing
        case noContent(userInfo: Any? = nil)
        case noNetwork(userInfo: Any? = nil)
        case fault(userInfo: Any? = nil)
    }
}

public protocol EmptyStateViewDataSource: AnyObject {
    func loadingIndicator(in view: EmptyStateView) -> LoadingIndicator?
    func noContentView(userInfo: Any?, in view: EmptyStateView) -> UIView?
    func noNetworkView(userInfo: Any?, in view: EmptyStateView) -> UIView?
    func faultView(userInfo: Any?, in view: EmptyStateView) -> UIView?
    func contentEdgeInsets(in view: EmptyStateView) -> UIEdgeInsets?
}

extension EmptyStateViewDataSource {
    public func loadingIndicator(in view: EmptyStateView) -> LoadingIndicator? {
        if #available(iOS 13, *) {
            return UIActivityIndicatorView(style: .medium)
        }
        return UIActivityIndicatorView(style: .gray)
    }

    public func noContentView(userInfo: Any?, in view: EmptyStateView) -> UIView? {
        return nil
    }

    public func noNetworkView(userInfo: Any?, in view: EmptyStateView) -> UIView? {
        return nil
    }

    public func faultView(userInfo: Any?, in view: EmptyStateView) -> UIView? {
        return nil
    }

    public func contentEdgeInsets(in view: EmptyStateView) -> UIEdgeInsets? {
        return nil
    }
}
