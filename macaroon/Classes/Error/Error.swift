// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public enum Error: Swift.Error {
    case appTargetNotFound
    case appTargetCorrupted(reason: Swift.Error)
    case screenNotFound
    case dismissNavigationBarItemNotFound
    case popNavigationBarItemNotFound
    case colorNotFound(String)
    case imageNotFound(String)
    case layoutConstraintCorrupted(reason: String)
    case unsupportedListCell(UICollectionViewCell.Type)
    case unsupportedListHeader(UICollectionReusableView.Type)
    case unsupportedListFooter(UICollectionReusableView.Type)
    case unsupportedListSupplementaryView(UICollectionReusableView.Type, String)
    case unsupportedListLayout
    case ambiguous
}

extension Error {
    public var localizedDescription: String {
        switch self {
        case .appTargetNotFound:
            return "App Target not found"
        case .appTargetCorrupted(let reason):
            return "App Target corrupted: \(reason.localizedDescription)"
        case .screenNotFound:
            return "Screen not found"
        case .dismissNavigationBarItemNotFound:
            return "Navigation bar button item not found for dismissing action"
        case .popNavigationBarItemNotFound:
            return "Navigation bar button item not found for popping action"
        case .colorNotFound(let name):
            return "Color(\(name)) not found"
        case .imageNotFound(let name):
            return "Image(\(name)) not found"
        case .layoutConstraintCorrupted(let reason):
            return "Layout Constraint corrupted: \(reason)"
        case .unsupportedListCell(let cellClass):
            return "Unsupported list cell \(String(describing: cellClass.self))"
        case .unsupportedListHeader(let headerClass):
            return "Size should return zero if the header will not be supported \(String(describing: headerClass.self))"
        case .unsupportedListFooter(let footerClass):
            return "Size should return zero if the footer will not be supported \(String(describing: footerClass.self))"
        case .unsupportedListSupplementaryView(let supplementaryViewClass, let kind):
            return "Unsupported supplementary view \(String(describing: supplementaryViewClass.self)) for \(kind)"
        case .unsupportedListLayout:
            return "This protocol can't form a layout other than UICollectionViewFlowLayout"
        case .ambiguous:
            return "Ambiguous error"
        }
    }
}
