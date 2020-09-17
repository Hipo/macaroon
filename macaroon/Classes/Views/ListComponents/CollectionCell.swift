// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class CollectionCell<ContextView: ViewComposable & ListReusable>: UICollectionViewCell, ListComposable, ListSeparatorAdaptable {
    open class var separatorStyle: ListSeparatorStyle {
        return .none
    }

    public private(set) lazy var contextView = getContextView()
    public private(set) lazy var separatorView = UIView()

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
        addContext()
        addSeparator()
    }

    open func addContext() {
        contentView.addSubview(contextView)
        contextView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview().inset(Self.separatorStyle.margin)
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

extension CollectionCell {
    private func addSeparator() {
        switch Self.separatorStyle {
        case .none:
            return
        case .single(let separator, let padding):
            if separatorView.isDescendant(of: contentView) { return }
            separatorView = contentView.addSeparator(separator, at: .bottom)
        }
    }
}
