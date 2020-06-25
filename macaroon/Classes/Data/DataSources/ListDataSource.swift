// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ListDataSource {
    subscript(section: Int) -> Any? { get }
    subscript(indexPath: IndexPath) -> Any? { get }

    func isEmpty() -> Bool
    func isSectionEmpty(_ section: Int) -> Bool
    func numberOfSections() -> Int
    func numberOfItems(inSection section: Int) -> Int
    func section(of item: Any) -> Int?
    func indexPath(of item: Any) -> IndexPath?
}

public protocol SingleListDataSource: ListDataSource {
    associatedtype List: Collection

    var list: List { get }

    subscript(indexPath: IndexPath) -> List.Element { get }

    func indexPath(of item: List.Element) -> IndexPath?
}

extension SingleListDataSource {
    public subscript(section: Int) -> Any? {
        return list
    }

    public subscript(indexPath: IndexPath) -> Any? {
        let elem: List.Element = self[indexPath]
        return elem
    }

    public func isEmpty() -> Bool {
        return isSectionEmpty(0)
    }

    public func isSectionEmpty(_ section: Int) -> Bool {
        return list.isEmpty
    }

    public func numberOfSections() -> Int {
        return 1
    }

    public func numberOfItems(inSection section: Int) -> Int {
        return list.count
    }

    public func section(of item: Any) -> Int? {
        return 0
    }

    public func indexPath(of item: Any) -> IndexPath? {
        if let validItem = item as? List.Element {
            return indexPath(of: validItem)
        }
        return nil
    }
}

extension SingleListDataSource where List.Index == Int {
    public subscript(indexPath: IndexPath) -> List.Element {
        return list[indexPath.item]
    }
}

extension SingleListDataSource where List.Index == Int, List.Element: Equatable {
    public func indexPath(of item: List.Element) -> IndexPath? {
        if let i = list.firstIndex(of: item) {
            return IndexPath(item: i, section: 0)
        }
        return nil
    }
}

public protocol SectionedListDataSource: ListDataSource {
    associatedtype List: Collection where List.Element: Collection

    var list: List { get }

    subscript(section: Int) -> List.Element { get }
    subscript(indexPath: IndexPath) -> List.Element.Element { get }

    func section(of item: List.Element) -> Int?
    func indexPath(of item: List.Element.Element) -> IndexPath?
}

extension SectionedListDataSource {
    public subscript(section: Int) -> Any? {
        let elem: List.Element = self[section]
        return elem
    }

    public subscript(indexPath: IndexPath) -> Any? {
        let elem: List.Element.Element = self[indexPath]
        return elem
    }

    public func isEmpty() -> Bool {
        return !((0..<numberOfSections()).contains { !isSectionEmpty($0) })
    }

    public func numberOfSections() -> Int {
        return list.count
    }

    public func section(of item: Any) -> Int? {
        if let validItem = item as? List.Element {
            return section(of: validItem)
        }
        return nil
    }

    public func indexPath(of item: Any) -> IndexPath? {
        if let validItem = item as? List.Element.Element {
            return indexPath(of: validItem)
        }
        return nil
    }
}

extension SectionedListDataSource where List.Index == Int {
    public subscript(section: Int) -> List.Element {
        return list[section]
    }

    public func isSectionEmpty(_ section: Int) -> Bool {
        return list[section].isEmpty
    }

    public func numberOfItems(inSection section: Int) -> Int {
        return list[section].count
    }
}

extension SectionedListDataSource where List.Index == Int, List.Element: Equatable {
    public func section(of item: List.Element) -> Int? {
        return list.firstIndex(of: item)
    }
}

extension SectionedListDataSource where List.Index == Int, List.Element.Index == Int {
    public subscript(indexPath: IndexPath) -> List.Element.Element {
        return list[indexPath.section][indexPath.item]
    }
}

extension SectionedListDataSource where List.Index == Int, List.Element.Index == Int, List.Element.Element: Equatable {
    public func indexPath(of item: List.Element.Element) -> IndexPath? {
        for (section, items) in list.enumerated() {
            if let index = items.firstIndex(of: item) {
                return IndexPath(item: index, section: section)
            }
        }
        return nil
    }
}
