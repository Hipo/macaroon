// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public enum SeperatorStyle {
    case none
    case single(Seperator)
}

open class CollectionCell<ContextView: ViewComposable>: UICollectionViewCell, ListComposable {
    public lazy var contextView = getContextView()
    
    open var seperatorStyle: SeperatorStyle {
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
        addSeperatorView()
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
    private func addSeperatorView() {
        switch seperatorStyle {
        case .none:
            return
        case let .single(seperator):
            addSeperator(seperator, at: .bottom)
        }
    }
}
