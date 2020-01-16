// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public protocol ListSupplementaryViewComposable: ViewComposable {
    associatedtype ContextViewLaunchArgs: ViewLaunchArgsConvertible
    associatedtype ContextView: View<ContextViewLaunchArgs>

    var contextView: ContextView { get }
}

extension ListSupplementaryViewComposable {
    public func addContextView() {
        addSubview(contextView)
        contextView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
}

public protocol BindableListSupplementaryViewComposable: ListSupplementaryViewComposable, ViewModelBindable where ContextViewLaunchArgs: BindableViewLaunchArgsConvertible, ContextView: ViewModelBindable, ContextView.ViewModel == ViewModel { }

extension BindableListSupplementaryViewComposable {
    public func bind(_ viewModel: ViewModel) {
        contextView.bind(viewModel)
    }

    public static func preferredSize(fittingSize: CGSize, by viewModel: ViewModel) -> CGSize {
        return ContextView.preferredSize(fittingSize: fittingSize, by: viewModel)
    }
}
