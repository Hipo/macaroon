// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class CollectionSupplementaryView<ContextView: ViewComposable & ListReusable>: UICollectionReusableView, ListComposable {
    public lazy var contextView = getContextView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
        setListeners()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func prepareLayout() {
        addContextView()
    }

    open func addContextView() {
        addSubview(contextView)
        contextView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }

    open func setListeners() { }

    open func getContextView() -> ContextView {
        return ContextView()
    }

    open override func prepareForReuse() {
        contextView.prepareForReuse()
    }
}
