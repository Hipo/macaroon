// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public protocol AlertUIContentConfigurable: ModalCustomPresentable {
    var contentAreaInsets: UIEdgeInsets? { get }

    func calculateContentAreaHeightFitting(
        _ targetSize: CGSize
    ) -> CGFloat
}

extension AlertUIContentConfigurable {
    public var contentAreaInsets: UIEdgeInsets? {
        return nil
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

public protocol AlertUIScrollContentConfigurable: AlertUIContentConfigurable {
    var scrollView: UIScrollView { get }
}

extension AlertUIScrollContentConfigurable where Self: ScrollScreen {
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

extension AlertUIScrollContentConfigurable where Self: ListScreen {
    public var scrollView: UIScrollView {
        return listView
    }

    public func calculateContentAreaHeightFitting(
        _ targetSize: CGSize
    ) -> CGFloat {
        return listView.bounds.size.height
    }
}
