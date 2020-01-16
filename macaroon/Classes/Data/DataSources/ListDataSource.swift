// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ListDataSource {
    subscript(section: Int) -> Any? { get }
    subscript(indexPath: IndexPath) -> Any? { get }

    func isEmpty() -> Bool
    func isSectionEmpty(_ section: Int) -> Bool
    func numberOfSections() -> Int
    func numberOfItems(inSection section: Int) -> Int
}

public protocol SingleListDataSource: ListDataSource {
    associatedtype List: Collection

    var list: List { get }

    subscript(indexPath: IndexPath) -> List.Element { get }
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
}

extension SingleListDataSource where List.Index == Int {
    public subscript(indexPath: IndexPath) -> List.Element {
        return list[indexPath.item]
    }
}

public protocol SectionedListDataSource: ListDataSource {
    associatedtype List: Collection where List.Element: Collection

    var list: List { get }

    subscript(section: Int) -> List.Element { get }
    subscript(indexPath: IndexPath) -> List.Element.Element { get }
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

extension SectionedListDataSource where List.Index == Int, List.Element.Index == Int {
    public subscript(indexPath: IndexPath) -> List.Element.Element {
        return list[indexPath.section][indexPath.item]
    }
}
