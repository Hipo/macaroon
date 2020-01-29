// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class ListScreen<SomeListDataConnector: ListDataSource, SomeListLayout: ListLayout, SomeScreenLaunchArgs: ScreenLaunchArgsConvertible, SomeRouter: Router>: Screen<SomeScreenLaunchArgs, SomeRouter>, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ListEmptyViewDataSource {
    public typealias DataConnector = SomeListDataConnector
    public typealias Layout = SomeListLayout

    public lazy var listView = ListView(listLayout: layout)

    public let dataConnector: DataConnector
    public let layout: Layout

    public init(
        dataConnector: DataConnector,
        layout: Layout,
        launchArgs: SomeScreenLaunchArgs
    ) {
        self.dataConnector = dataConnector
        self.layout = layout
        super.init(launchArgs: launchArgs)
    }

    open override func customizeAppearance() {
        super.customizeAppearance()
        customizeListViewAppearance()
    }

    open func customizeListViewAppearance() { }

    open override func prepareLayout() {
        super.prepareLayout()
        addListView()
    }

    open func addListView() {
        view.addSubview(listView)
        listView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }

    open override func setListeners() {
        super.setListeners()
        listView.dataSource = self
        listView.delegate = self
        listView.emptyStateDataSource = self
    }

    open override func viewDidChangePreferredContentSizeCategory() {
        super.viewDidChangePreferredContentSizeCategory()
        layout.invalidate()
        updateLayoutWhenViewDidLayoutSubviews()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        finalizeListViewLayout()
    }

    /// <warning> Define ObjC protocols(i.e. UICollectionViewDataSource etc.) in base for the generic types to be able to override them in subclasses.

    /// <mark> UICollectionViewDataSource
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataConnector.numberOfSections()
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataConnector.numberOfItems(inSection: section)
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return layout.cell(for: dataConnector[indexPath], at: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return layout.header(for: dataConnector[indexPath.section], in: indexPath.section)
        case UICollectionView.elementKindSectionFooter:
            return layout.footer(for: dataConnector[indexPath.section], in: indexPath.section)
        default:
            mc_crash(.unsupportedListSupplementaryView(kind))
        }
    }

    /// <mark> UICollectionViewDelegateFlowLayout
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return layout.size(for: dataConnector[indexPath], at: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if dataConnector.isSectionEmpty(section) &&
           !layout.shouldShowHeadersForEmptySection(section) {
            return .zero
        }
        return layout.headerSize(for: dataConnector[section], in: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if dataConnector.isSectionEmpty(section) &&
           !layout.shouldShowFooterForEmptySection(section) {
            return .zero
        }
        return layout.footerSize(for: dataConnector[section], in: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if dataConnector.isSectionEmpty(section) {
            return 0.0
        }
        return layout.minimumLineSpacing(for: dataConnector[section], in: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if dataConnector.isSectionEmpty(section) {
            return 0.0
        }
        return layout.minimumInteritemSpacing(for: dataConnector[section], in: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if dataConnector.isSectionEmpty(section) {
            return .zero
        }
        return layout.sectionInset(for: dataConnector[section], in: section)
    }

    /// <mark> UICollectionViewDelegate
    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader ||
           elementKind == UICollectionView.elementKindSectionFooter {
            view.layer.zPosition = 0.0
        }
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) { }
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) { }
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) { }
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) { }

    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    open func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    /// <mark> UIScrollViewDelegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { }
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) { }
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { }
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) { }

    /// <mark> ListEmptyViewDataSource
    open func loadingIndicator(in view: ListEmptyView) -> LoadingIndicator? {
        let loadingIndicator: UIActivityIndicatorView

        if #available(iOS 13, *) {
            loadingIndicator = UIActivityIndicatorView(style: .medium)
        } else {
            loadingIndicator = UIActivityIndicatorView(style: .gray)
        }
        return loadingIndicator
    }

    open func loadingIndicatorVerticalPositionAdjustment(in view: ListEmptyView) -> CGFloat? {
        return nil
    }

    open func noContentView(in view: ListEmptyView) -> UIView? {
        return nil
    }

    open func noNetworkView(in view: ListEmptyView) -> UIView? {
        return nil
    }

    open func faultView(in view: ListEmptyView) -> UIView? {
        return nil
    }
}

extension ListScreen {
    private func finalizeListViewLayout() {
        layout.prepareForUse()
    }
}
