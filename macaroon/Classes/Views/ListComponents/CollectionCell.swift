// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public enum SeparatorStyle {
    case none
    case single(Separator)
}

open class CollectionCell<ContextView: ViewComposable & ListReusable>: UICollectionViewCell, ListComposable {
    public lazy var contextView = getContextView()
    
    open var separatorStyle: SeparatorStyle {
        return .none
    }

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
        addSeparatorView()
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

    open func getContextView() -> ContextView {
        return ContextView()
    }

    open override func prepareForReuse() {
        contextView.prepareForReuse()
    }
}

extension CollectionCell {
    @discardableResult
    open func addSeparatorView() -> UIView? {
        switch separatorStyle {
        case .none:
            return nil
        case let .single(separator):
            return addSeparator(separator, at: .bottom)
        }
    }
}
