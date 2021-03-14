// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class RemoteListScreen: ListScreen, ListDataLoaderDelegate {
    public var reloadListWhenViewDidAppear = true
    public var reloadListWhenViewWillEnterForeground = true
    public var invalidatesLayoutForReloadingItems = false

    public let listDataLoader: ListDataLoader

    private var lastActiveDate: Date?

    public init(
        listDataLoader: ListDataLoader & ListDataSource,
        listLayout: ListLayout,
        configurator: ScreenConfigurable? = nil
    ) {
        self.listDataLoader = listDataLoader
        super.init(listDataSource: listDataLoader, listLayout: listLayout, configurator: configurator)
    }

    open override func observeNotifications() {
        super.observeNotifications()
        observeApplicationLifeCycleNotifications()
    }

    open override func setListeners() {
        super.setListeners()
        listDataLoader.delegate = self
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        listDataLoader.loadList()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if reloadListWhenViewDidAppear, !isViewFirstAppeared {
            listDataLoader.reloadList()
        }
    }

    open override func viewWillEnterForeground() {
        super.viewWillEnterForeground()

        if reloadListWhenViewWillEnterForeground {
            if let lastActiveDate = lastActiveDate, Date().timeIntervalSince(lastActiveDate) > 24 * 60 * 60 { /// <mark> 1 day
                listDataLoader.loadList()
            } else {
                listDataLoader.reloadList()
            }
        }
        lastActiveDate = nil
    }

    open override func viewDidEnterBackground() {
        super.viewDidEnterBackground()

        if reloadListWhenViewWillEnterForeground {
            lastActiveDate = Date()
        }
    }

    open override func viewDidAppearAfterInteractiveDismiss() {
        super.viewDidAppearAfterInteractiveDismiss()

        if reloadListWhenViewDidAppear {
            listDataLoader.reloadList()
        }
    }

    /// <mark> ListDataLoaderDelegate
    open func listDataLoaderWillLoadList(_ dataLoader: ListDataLoader) {
        if listDataSource.isEmpty() {
            switch listView.emptyState {
            case .none,
                 .noNetwork,
                 .fault:
                listView.emptyState = .loading
            default:
                break
            }
        }
    }

    open func listDataLoader(_ dataLoader: ListDataLoader, didLoadList modifier: ListModifier) {
        reloadList(modifier) {
            self.listView.emptyState = self.listDataSource.isEmpty() ? .noContent() : .none
        }
    }

    open func listDataLoader(_ dataLoader: ListDataLoader, didFailToLoadList error: ListError) {
        switch error.reason {
        case .network:
            dataLoader.unloadList()
            listView.emptyState = .noNetwork(userInfo: error.userInfo)
        default:
            listView.emptyState = .fault(userInfo: error.userInfo)
        }
    }

    open func listDataLoaderWillLoadNextList(_ dataLoader: ListDataLoader) {
    }

    open func listDataLoader(_ dataLoader: ListDataLoader, didLoadNextList modifier: ListModifier) {
        reloadList(modifier)
    }

    open func listDataLoader(_ dataLoader: ListDataLoader, didFailToLoadNextList error: ListError) {
        switch error.reason {
        case .network:
            dataLoader.unloadList()
            listView.emptyState = .noNetwork(userInfo: error.userInfo)
        default:
            break
        }
    }

    open func listDataLoaderWillReloadList(_ dataLoader: ListDataLoader) {
        listDataLoaderWillLoadList(dataLoader)
    }

    open func listDataLoader(_ dataLoader: ListDataLoader, didReloadList modifier: ListModifier) {
        listDataLoader(dataLoader, didLoadList: modifier)
    }

    open func listDataLoader(_ dataLoader: ListDataLoader, didFailToReloadList error: ListError) {
        listDataLoader(dataLoader, didFailToLoadList: error)
    }

    open func listDataLoaderDidUnloadList(_ dataLoader: ListDataLoader) {
        listView.reloadData()
    }

    /// <mark> UIScrollViewDelegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.bounds.height

        if contentHeight <= scrollHeight ||
           contentHeight - scrollView.contentOffset.y < 2 * scrollHeight {
            listDataLoader.loadNextList()
            return
        }
    }
}

extension RemoteListScreen {
    public func reloadList(_ modifier: ListModifier, onCompleted execute: (() -> Void)? = nil) {
        switch modifier {
        case .none:
            execute?()
        case .reload:
            listView.reloadData()
            execute?()
        case .update(let listSnapshot, let applyUpdates):
            if !listSnapshot.hasUpdates {
                execute?()
                return
            }
            if !isViewAppeared {
                listView.reloadData()
                execute?()
                return
            }
            performBatchUpdates(listSnapshot, onStarted: applyUpdates, onCompleted: execute)
        }
    }

    public func performBatchUpdates(_ listSnapshot: ListSnapshot, onStarted executeOnStarted: (() -> Void)?, onCompleted executeOnCompleted: (() -> Void)?) {
        if !listSnapshot.hasUpdates {
            executeOnStarted?()
            executeOnCompleted?()
            return
        }
        let listUpdates = listSnapshot.updates

        for offset in listUpdates.reloads {
            let indexPath = IndexPath(item: offset, section: listUpdates.section)

            if let cell = listView.cellForItem(at: indexPath) {
                listLayout.configure(cell, with: listSnapshot[indexPath], at: indexPath)
            }
        }
        for move in listUpdates.moves where move.isMutated {
            let srcIndexPath = IndexPath(item: move.source, section: listUpdates.section)
            let destIndexPath = IndexPath(item: move.destination, section: listUpdates.section)

            if let cell = listView.cellForItem(at: srcIndexPath) {
                listLayout.configure(cell, with: listSnapshot[destIndexPath], at: srcIndexPath)
            }
        }
        listView.performBatchUpdates(
            {
                executeOnStarted?()

                for offset in listUpdates.inserts {
                    let indexPath = IndexPath(item: offset, section: listUpdates.section)
                    listView.insertItems(at: [indexPath])
                }
                for offset in listUpdates.deletes {
                    let indexPath = IndexPath(item: offset, section: listUpdates.section)
                    listView.deleteItems(at: [indexPath])
                }
                for move in listUpdates.moves {
                    let srcIndexPath = IndexPath(item: move.source, section: listUpdates.section)
                    let destIndexPath = IndexPath(item: move.destination, section: listUpdates.section)
                    listView.moveItem(at: srcIndexPath, to: destIndexPath)
                }
            },
            completion: { _ in
                if self.invalidatesLayoutForReloadingItems {
                    let reloadingIndexPaths = listUpdates.reloads.map { IndexPath(item: $0, section: listUpdates.section) }
                    self.listLayout.invalidateItems(at: reloadingIndexPaths)
                }
                executeOnCompleted?()
            }
        )
    }
}
