// Copyright © Hipolabs. All rights reserved.

import Foundation
import os.log

public struct Logger<Category: LogCategory>: Printable {
    public var isEnabled = false

    public var allowedCategories = Category.allCases
    public var allowedLevels = LogLevel.allCases

    public var debugDescription: String {
        return """
        Subsystem: \(subsystem)
        Categories: \(allowedCategories.map(\.debugDescription).joined(separator: ","))
        Levels: \(allowedLevels.map(\.debugDescription).joined(separator: ","))
        """
    }

    public let subsystem: String

    public init(
        subsystem: String
    ) {
        self.subsystem = subsystem
    }

    public func log(
        _ instance: Log<Category>
    ) {
        if !isEnabled {
            return
        }

        if !allowedLevels.contains(.debug) &&
           !allowedLevels.contains(instance.level) {
            return
        }

        let tag = OSLog(subsystem: subsystem, category: instance.category.description)
        os_log("%{private}@", log: tag, type: instance.level.osLogType, instance.message)
    }
}

public struct Log<Category: LogCategory>:
    ExpressibleByStringLiteral,
    Printable {
    public var debugDescription: String {
        return "[\(category.debugDescription)][\(level.debugDescription)]\(message)"
    }

    public let message: String
    public let category: Category
    public let level: LogLevel

    public init(
        message: String,
        category: Category = .default,
        level: LogLevel = .debug
    ) {
        self.message = message
        self.category = category
        self.level = level
    }

    public init(stringLiteral value: String) {
        self.init(message: value)
    }
}

public protocol LogCategory:
    CaseIterable,
    Equatable,
    Printable {
    static var `default`: Self { get }
}

public enum LogLevel:
    CaseIterable,
    Printable {
    case info
    case warning
    case error
    case debug /// <note> debug = info + warning + error
}

extension LogLevel {
    public var debugDescription: String {
        switch self {
        case .info: return "Info"
        case .warning: return "Warning"
        case .error: return "Error"
        case .debug: return "Debug"
        }
    }

    var osLogType: OSLogType {
        switch self {
        case .info: return .info
        case .warning: return .fault
        case .error: return .error
        case .debug: return .debug
        }
    }
}
