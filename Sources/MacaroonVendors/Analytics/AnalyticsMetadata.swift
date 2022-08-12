// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils

public protocol AnalyticsMetadata:
    Collection,
    ExpressibleByDictionaryLiteral,
    Printable
where
    Self.Key: AnalyticsMetadataKey,
    Self.Element == (key: Self.Key, value: Self.Value) {}

extension Dictionary: AnalyticsMetadata where
    Self.Key: AnalyticsMetadataKey {}

public protocol AnalyticsMetadataKey:
    RawRepresentable,
    Hashable,
    Printable
where Self.RawValue == String {}
