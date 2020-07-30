// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public enum Error: ErrorConvertible {
    case targetNotFound
    case targetCorrupted(reason: ErrorConvertible)
    case unsupportedDeviceOS
    case unsupportedDeviceFamily
    case rootContainerNotMatch
    case screenNotFound(RouteDestination)
    case dismissNavigationBarItemNotFound
    case popNavigationBarItemNotFound
    case colorNotFound(String)
    case imageNotFound(String)
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
        case .targetNotFound:
            return "Target not found"
        case .targetCorrupted(let reason):
            return "Target corrupted: \(reason.localizedDescription)"
        case .unsupportedDeviceOS:
            return "Unsupported device operating system"
        case .unsupportedDeviceFamily:
            return "Unsupported device family"
        case .rootContainerNotMatch:
            return "Root container in window doesn't match the expected one"
        case .screenNotFound(let destination):
            return "Screen not found for \(destination)"
        case .dismissNavigationBarItemNotFound:
            return "Navigation bar button item not found for dismissing action"
        case .popNavigationBarItemNotFound:
            return "Navigation bar button item not found for popping action"
        case .colorNotFound(let name):
            return "Color(\(name)) not found"
        case .imageNotFound(let name):
            return "Image(\(name)) not found"
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
