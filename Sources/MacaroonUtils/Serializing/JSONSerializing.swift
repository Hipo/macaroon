// Copyright © Hipolabs. All rights reserved.

import Foundation

extension Encodable {
    public func encoded(
        _ encodingStrategy: JSONEncodingStrategy
    ) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = encodingStrategy.keys
        encoder.dateEncodingStrategy = encodingStrategy.date
        encoder.dataEncodingStrategy = encodingStrategy.data
        return try encoder.encode(self)
    }
}

extension Decodable {
    public static func decoded(
        _ data: Data,
        using decodingStrategy: JSONDecodingStrategy
    ) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = decodingStrategy.keys
        decoder.dateDecodingStrategy = decodingStrategy.date
        decoder.dataDecodingStrategy = decodingStrategy.data
        return
            try decoder.decode(
                Self.self,
                from: data
            )
    }
}

public struct JSONEncodingStrategy: Printable {
    public typealias Keys = JSONEncoder.KeyEncodingStrategy
    public typealias Date = JSONEncoder.DateEncodingStrategy
    public typealias Data = JSONEncoder.DataEncodingStrategy

    public var debugDescription: String {
        return "[JSON Encoding] keys:\(keys) date:\(date) data:\(data)"
    }

    public let keys: Keys
    public let date: Date
    public let data: Data

    public init(
        keys: Keys = .useDefaultKeys,
        date: Date = .deferredToDate,
        data: Data = .base64
    ) {
        self.keys = keys
        self.date = date
        self.data = data
    }
}

public struct JSONDecodingStrategy: Printable {
    public typealias Keys = JSONDecoder.KeyDecodingStrategy
    public typealias Date = JSONDecoder.DateDecodingStrategy
    public typealias Data = JSONDecoder.DataDecodingStrategy

    public var debugDescription: String {
        return "[JSON Decoding] keys:\(keys) date:\(date) data:\(data)"
    }

    public let keys: Keys
    public let date: Date
    public let data: Data

    public init(
        keys: Keys = .useDefaultKeys,
        date: Date = .deferredToDate,
        data: Data = .base64
    ) {
        self.keys = keys
        self.date = date
        self.data = data
    }
}
