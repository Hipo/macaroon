// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension Encodable {
    public func encoded(by encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}

extension Decodable {
    public static func decoded(_ data: Data, by decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}

extension JSONEncoder {
    public enum Encoding {
        case key(KeyEncodingStrategy)
        case date(DateEncodingStrategy)
        case data(DataEncodingStrategy)
    }

    convenience init(_ encoding: Encoding...) {
        self.init()

        for e in encoding {
            switch e {
            case .key(let strategy):
                keyEncodingStrategy = strategy
            case .date(let strategy):
                dateEncodingStrategy = strategy
            case .data(let strategy):
                dataEncodingStrategy = strategy
            }
        }
    }
}

extension JSONDecoder {
    public enum Decoding {
        case key(KeyDecodingStrategy)
        case date(DateDecodingStrategy)
        case data(DataDecodingStrategy)
    }

    convenience init(_ decoding: Decoding...) {
        self.init()

        for d in decoding {
            switch d {
            case .key(let strategy):
                keyDecodingStrategy = strategy
            case .date(let strategy):
                dateDecodingStrategy = strategy
            case .data(let strategy):
                dataDecodingStrategy = strategy
            }
        }
    }
}
