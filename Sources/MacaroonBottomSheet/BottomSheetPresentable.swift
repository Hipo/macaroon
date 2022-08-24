// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public protocol BottomSheetPresentable: ModalCustomPresentable {
    var modalBottomPadding: LayoutMetric { get }

    func calculateContentAreaHeightFitting(
        _ targetSize: CGSize
    ) -> CGFloat
}

extension BottomSheetPresentable {
    public var modalBottomPadding: LayoutMetric {
        return 0
    }

    public func calculateContentAreaHeightFitting(
        _ targetSize: CGSize
    ) -> CGFloat {
        let size = view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        return size.height
    }
}

public protocol BottomSheetScrollPresentable: BottomSheetPresentable {
    var scrollView: UIScrollView { get }
}

extension BottomSheetScrollPresentable where Self: ScrollScreen {
    public func calculateContentAreaHeightFitting(
        _ targetSize: CGSize
    ) -> CGFloat {
        let contentSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        let footerSize = footerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        return contentSize.height + footerSize.height
    }
}

extension BottomSheetScrollPresentable where Self: ListScreen {
    public var scrollView: UIScrollView {
        return listView
    }

    public func calculateContentAreaHeightFitting(
        _ targetSize: CGSize
    ) -> CGFloat {
        return listView.bounds.size.height
    }
}
