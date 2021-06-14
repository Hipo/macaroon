// Copyright © Hipolabs. All rights reserved.

import Foundation

public protocol JSONModel:
    Codable,
    DebugPrintable {
    var isFault: Bool { get }

    static var encodingStrategy: JSONEncodingStrategy { get }
    static var decodingStrategy: JSONDecodingStrategy { get }

    func encoded() throws -> Data

    static func decoded(_ data: Data) throws -> Self
}

extension JSONModel {
    public var isFault: Bool {
        return false
    }

    public var debugDescription: String {
        do {
            let data = try encoded()
            return "[\(type(of: self))] \(data.utf8Description)"
        } catch {
            return "<invalid>"
        }
    }

    public static var encodingStrategy: JSONEncodingStrategy {
        return JSONEncodingStrategy()
    }
    public static var decodingStrategy: JSONDecodingStrategy {
        return JSONDecodingStrategy()
    }

    public func encoded() throws -> Data {
        return try encoded(Self.encodingStrategy)
    }

    public static func decoded(
        _ data: Data
    ) throws -> Self {
        return
            try decoded(
                data,
                using: Self.decodingStrategy
            )
    }
}

extension JSONModel {
    public static func decoded(
        fromResource name: String,
        withExtension ext: String = "json"
    ) throws -> Self {
        guard let resourceUrl = Bundle.main.url(forResource: name, withExtension: ext) else {
            fatalError("The resource not found!")
        }

        do {
            let data = try Data(contentsOf: resourceUrl, options: Data.ReadingOptions.uncached)

            return
                try decoded(
                    data,
                    using: Self.decodingStrategy
                )
        } catch let err {
            throw err
        }
    }
}

extension Array: JSONModel where Element: JSONModel {
    public func encoded() throws -> Data {
        return try encoded(Element.encodingStrategy)
    }

    public static func decoded(
        _ data: Data
    ) throws -> Self {
        return
            try decoded(
                data,
                using: Element.decodingStrategy
            )
    }
}

public struct NoJSONModel: JSONModel { }
