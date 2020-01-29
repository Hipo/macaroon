// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class CollectionCell<ContextView: UIView>: UICollectionViewCell, ListPresentable {
    public lazy var contextView = getContextView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        customizeAppearance()
        prepareLayout()
        setListeners()
        linkInteractors()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func customizeAppearance() { }

    open func prepareLayout() {
        addContextView()
    }

    open func addContextView() {
        contentView.addSubview(contextView)
        contextView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }

    open func setListeners() { }
    open func linkInteractors() { }

    open func getContextView() -> ContextView {
        return ContextView()
    }

    open override func prepareForReuse() {
        contextView.prepareForReuse()
    }
}
