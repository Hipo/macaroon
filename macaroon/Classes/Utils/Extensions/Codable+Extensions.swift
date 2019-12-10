// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

/// <mark> Encoding
extension Encodable {
    public func encoded(by encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}

extension JSONEncoder {
    public enum EncodingStrategy {
        case key(KeyEncodingStrategy)
        case date(DateEncodingStrategy)
        case data(DataEncodingStrategy)
    }

    convenience init(_ strategy: EncodingStrategy...) {
        self.init()

        for s in strategy {
            switch s {
            case .key(let keyStrategy):
                keyEncodingStrategy = keyStrategy
            case .date(let dateStrategy):
                dateEncodingStrategy = dateStrategy
            case .data(let dataStrategy):
                dataEncodingStrategy = dataStrategy
            }
        }
    }
}

/// <mark> Decoding
extension Decodable {
    public static func decoded(_ data: Data, by decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}

extension JSONDecoder {
    public enum DecodingStrategy {
        case key(KeyDecodingStrategy)
        case date(DateDecodingStrategy)
        case data(DataDecodingStrategy)
    }

    convenience init(_ strategy: DecodingStrategy...) {
        self.init()

        for s in strategy {
            switch s {
            case .key(let keyStrategy):
                keyDecodingStrategy = keyStrategy
            case .date(let dateStrategy):
                dateDecodingStrategy = dateStrategy
            case .data(let dataStrategy):
                dataDecodingStrategy = dataStrategy
            }
        }
    }
}
