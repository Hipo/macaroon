// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public class EmptyStateView: UIView {
    public var state: State = .none {
        didSet { updateContentWhenStateChanged() }
    }

    public weak var dataSource: EmptyStateViewDataSource?

    private var currentContent: UIView?
}

extension EmptyStateView {
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

extension EmptyStateView {
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
        dataSource?.noContentView(in: self).continue(ifPresent: addContent(_:))
    }

    private func addNoNetworkView() {
        dataSource?.noNetworkView(in: self).continue(ifPresent: addContent(_:))
    }

    private func addFaultView() {
        dataSource?.faultView(in: self).continue(ifPresent: addContent(_:))
    }

    private func addContent(_ content: UIView) {
        addSubview(content)
        content.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }

        currentContent = content
    }
}

extension EmptyStateView {
    public enum State {
        case none
        case loading
        case refreshing /// <note> The state for pull-to-refresh if present
        case noContent
        case noNetwork
        case fault
    }
}

public protocol EmptyStateViewDataSource: AnyObject {
    func loadingIndicator(in view: EmptyStateView) -> LoadingIndicator?
    func loadingIndicatorVerticalPositionAdjustment(in view: EmptyStateView) -> CGFloat?
    func noContentView(in view: EmptyStateView) -> UIView?
    func noNetworkView(in view: EmptyStateView) -> UIView?
    func faultView(in view: EmptyStateView) -> UIView?
}

extension EmptyStateViewDataSource {
    public func loadingIndicator(in view: EmptyStateView) -> LoadingIndicator? {
        let loadingIndicator: UIActivityIndicatorView

        if #available(iOS 13, *) {
            loadingIndicator = UIActivityIndicatorView(style: .medium)
        } else {
            loadingIndicator = UIActivityIndicatorView(style: .gray)
        }
        return loadingIndicator
    }

    public func loadingIndicatorVerticalPositionAdjustment(in view: EmptyStateView) -> CGFloat? {
        return nil
    }

    public func noContentView(in view: EmptyStateView) -> UIView? {
        return nil
    }

    public func noNetworkView(in view: EmptyStateView) -> UIView? {
        return nil
    }

    public func faultView(in view: EmptyStateView) -> UIView? {
        return nil
    }
}
