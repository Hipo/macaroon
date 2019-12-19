//___FILEHEADER___

import Foundation

class ___FILEBASENAMEASIDENTIFIER___: ListLayout {

    // MARK: - Typealiases

    typealias Cell = <#name#>CollectionCell<<#name#>ViewStyleGuide, <#name#>ViewModel>

    // MARK: - Properties

    private let layout = Layout<LayoutConstants>().current

    // MARK: - ListLayout

    func prepareForUse() {

    }

    func dequeueCell(for item: Any?, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let listView = listView else {
            fatalError("List must not be nil. Please use UICollectionView.init(listLayout:).")
        }
        if item is <#Type#> {
            return listView.dequeueReusableCell(withReuseIdentifier: Cell.reusableIdentifier, for: indexPath)
        }
        fatalError("No cell will be dequeued.")
    }

    func configure(_ cell: UICollectionViewCell, with item: Any?, at indexPath: IndexPath) {
        if let model = item as? <#Type#> {
            (cell as? Cell)?.bind(TeamMemberWorkStatusViewModel(avatarSize: layout.current.avatarSize, model: model))
            return
        }
    }

    func configure(header: UICollectionReusableView, with item: Any?, in section: Int) {
        if let model = item as? [<#Type#>] {
            (header as? Header)?.bind(<#name#>ViewModel(model: model))
            return
        }
    }
}

// MARK: - Layout Constants

extension ___FILEBASENAMEASIDENTIFIER___ {
    private struct LayoutConstants: AdaptiveLayoutConstants {

    }
}
