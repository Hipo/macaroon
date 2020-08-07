// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ListDataController: ListDataSource, ListDataLoader {
    var isLoadingList: Bool { get }
    var isLoadingNextList: Bool { get }

    func loadListData(onCompleted execute: @escaping (Result<ListModifier, ListError>) -> Void)
    func loadNextListData(onCompleted execute: @escaping (Result<ListModifier, ListError>) -> Void)
    func reloadListData(onCompleted execute: @escaping (Result<ListModifier, ListError>) -> Void)
    func unloadListData(onCompleted execute: @escaping () -> Void)
    func cancelListData() /// <note> Cancel both list data and reload list data endpoints. Both can be handled by a single endpoint handler.
    func cancelListNextData()
}

extension ListDataController {
    public var isLoadingNextList: Bool {
        return false
    }

    public func loadNextListData(onCompleted execute: @escaping (Result<ListModifier, ListError>) -> Void) {
        execute(.success(.none))
    }

    public func cancelListNextData() { }
}

extension ListDataController {
    public func loadList() {
        unloadList()

        delegate?.listDataLoaderWillLoadList(self)
        loadListData { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let listModifier):
                self.delegate?.listDataLoader(self, didLoadList: listModifier)
            case .failure(let listError):
                self.delegate?.listDataLoader(self, didFailToLoadList: listError)
            }
        }
    }

    public func loadNextList() {
        if !hasNextList { return }
        if isEmpty() { return }
        if isLoadingList || isLoadingNextList { return }

        delegate?.listDataLoaderWillLoadNextList(self)
        loadNextListData { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let listModifier):
                self.delegate?.listDataLoader(self, didLoadNextList: listModifier)
            case .failure(let listError):
                self.delegate?.listDataLoader(self, didFailToLoadNextList: listError)
            }
        }
    }

    public func reloadList() {
        if isEmpty() {
            loadList()
            return
        }
        cancelList()

        delegate?.listDataLoaderWillReloadList(self)
        reloadListData { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let listModifier):
                self.delegate?.listDataLoader(self, didReloadList: listModifier)
            case .failure(let listError):
                self.delegate?.listDataLoader(self, didFailToReloadList: listError)
            }
        }
    }

    public func unloadList() {
        cancelList()

        unloadListData { [weak self] in
            guard let self = self else { return }
            self.delegate?.listDataLoaderDidUnloadList(self)
        }
    }
}

extension ListDataController {
    public func cancelList() {
        cancelListNextData()
        cancelListData()
    }
}
