// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public protocol StorySheetPresentable: ModalCustomPresentable {
    var storySheetInset: LayoutMargins? { get }

    /// <note>
    /// If the presented screen has a scroll view, return it via this property, so that the
    /// interactive dismissal can be handled properly without messing with the scrolling behaviour.
    var presentedScrollView: UIScrollView? { get }
    var presentedScrollContentView: UIView? { get }
}

extension StorySheetPresentable {
    public var storySheetInset: LayoutMargins? {
        return nil
    }

    public var presentedScrollView: UIScrollView? {
        return nil
    }
    public var presentedScrollContentView: UIView? {
        return nil
    }
}

extension StorySheetPresentable where Self: ScrollScreen {
    var presentedScrollView: UIScrollView? {
        return scrollView
    }
    var presentedScrollContentView: UIView? {
        return contentView
    }
}

extension StorySheetPresentable where Self: ListScreen {
    var presentedScrollView: UIScrollView? {
        return listView
    }
}
