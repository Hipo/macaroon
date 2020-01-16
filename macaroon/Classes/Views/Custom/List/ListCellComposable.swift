// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public protocol ListCellComposable: ViewComposable {
    associatedtype ContextViewLaunchArgs: ViewLaunchArgsConvertible
    associatedtype ContextView: View<ContextViewLaunchArgs>

    var contentView: UIView { get }
    var contextView: ContextView { get }
}

extension ListCellComposable {
    public func customizeAppearance() { }

    public func prepareLayout() {
        addContextView()
    }
}

extension ListCellComposable {
    public func addContextView() {
        contentView.addSubview(contextView)
        contextView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
}

public protocol BindableListCellComposable: ListCellComposable, ViewModelBindable where ContextViewLaunchArgs: BindableViewLaunchArgsConvertible, ContextView: ViewModelBindable, ContextView.ViewModel == ViewModel { }

extension BindableListCellComposable {
    public func bind(_ viewModel: ViewModel) {
        contextView.bind(viewModel)
    }

    public static func preferredSize(fittingSize: CGSize, by viewModel: ViewModel) -> CGSize {
        return ContextView.preferredSize(fittingSize: fittingSize, by: viewModel)
    }
}
