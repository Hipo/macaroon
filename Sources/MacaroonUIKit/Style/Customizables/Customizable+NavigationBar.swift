// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Customizable where Self: UINavigationBar {
    public func customizeAppearance(
        _ style: NavigationBarStyle
    ) {
        customizeBarAppearance(opaque: style.isOpaque)
        customizeBarAppearance(titleAttributes: style.titleAttributes)
        customizeBarAppearance(largeTitleAttributes: style.largeTitleAttributes)
        customizeBarAppearance(backImage: style.backImage)
        customizeBarAppearance(shadowImage: style.shadowImage)
        customizeBarAppearance(shadowColor: style.shadowColor)
        customizeBarAppearance(backgroundImage: style.backgroundImage)
        customizeBaseAppearance(backgroundColor: style.backgroundColor)
        customizeBarAppearance(tintColor: style.tintColor)
    }

    public func recustomizeAppearance(
        _ style: NavigationBarStyle
    ) {
        resetAppearance()
        customizeAppearance(
            style
        )
    }

    public func resetAppearance() {
        resetBaseAppearance()

        customizeBarAppearance(
            backgroundColor: nil
        )
        customizeBarAppearance(
            tintColor: nil
        )
        customizeBarAppearance(
            opaque: false
        )
        customizeBarAppearance(
            backgroundImage: nil
        )
        customizeBarAppearance(
            shadowImage: nil
        )
        customizeBarAppearance(
            shadowColor: nil
        )
        customizeBarAppearance(
            titleAttributes: nil
        )
        customizeBarAppearance(
            largeTitleAttributes: nil
        )
    }
}

extension Customizable where Self: UINavigationBar {
    public func customizeBarAppearance(
        backgroundColor: Color?
    ) {
        if #available(iOS 13, *) {
            customizeBarAppearance(
                backgroundColor?.uiColor,
                \.backgroundColor
            )
        } else {
            self.barTintColor = backgroundColor?.uiColor
        }
    }

    public func customizeBarAppearance(
        tintColor: Color?
    ) {
        self.tintColor = tintColor?.uiColor
    }

    public func customizeBarAppearance(
        opaque: Bool?
    ) {
        let isOpaque = opaque ?? false

        self.isTranslucent = !isOpaque

        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()

            standardAppearance = appearance
            compactAppearance = appearance
            scrollEdgeAppearance = appearance
        }
    }

    public func customizeBarAppearance(
        backImage: Image?
    ) {
        if #available(iOS 13, *) {
            let standardAppearance = standardAppearance.copy()
            let compactAppearance = compactAppearance?.copy()
            let scrollEdgeAppearance = scrollEdgeAppearance?.copy()

            [standardAppearance, compactAppearance, scrollEdgeAppearance]
                .compactMap { $0 }
                .forEach {
                    $0.setBackIndicatorImage(
                        backImage?.uiImage,
                        transitionMaskImage: backImage?.uiImage
                    )
                }

            self.standardAppearance = standardAppearance
            self.compactAppearance = compactAppearance
            self.scrollEdgeAppearance = scrollEdgeAppearance
        } else {
            self.backIndicatorImage = backImage?.uiImage
            self.backIndicatorTransitionMaskImage = backImage?.uiImage
        }
    }

    public func customizeBarAppearance(
        backgroundImage: Image?
    ) {
        if #available(iOS 13, *) {
            customizeBarAppearance(
                backgroundImage?.uiImage,
                \.backgroundImage
            )
        } else {
            self.setBackgroundImage(
                backgroundImage?.uiImage,
                for: .default
            )
        }
    }

    public func customizeBarAppearance(
        shadowImage: Image?
    ) {
        if #available(iOS 13, *) {
            customizeBarAppearance(
                shadowImage?.uiImage,
                \.shadowImage
            )
        } else {
            self.shadowImage = shadowImage?.uiImage
        }
    }

    public func customizeBarAppearance(
        shadowColor: Color?
    ) {
        if #available(iOS 13, *) {
            customizeBarAppearance(
                shadowColor?.uiColor,
                \.shadowColor
            )
        }
    }

    public func customizeBarAppearance(
        titleAttributes: [NSAttributedString.Key: Any]?
    ) {
        if #available(iOS 13, *) {
            customizeBarAppearance(
                titleAttributes ?? [:],
                \.titleTextAttributes
            )
        } else {
            self.titleTextAttributes = titleAttributes
        }
    }

    public func customizeBarAppearance(
        largeTitleAttributes: [NSAttributedString.Key: Any]?
    ) {
        /// <note> Don't support large title for iOS 13 and later.
        if #available(iOS 13, *) {
            if LayoutFamily.current == .extraSmall {
                self.prefersLargeTitles = false
                return
            }

            self.prefersLargeTitles = largeTitleAttributes != nil

            customizeBarAppearance(
                largeTitleAttributes ?? [:],
                \.largeTitleTextAttributes
            )
        } else {
            self.prefersLargeTitles = false
        }
    }
}

@available(iOS 13, *)
extension Customizable where Self: UINavigationBar {
    public func customizeBarAppearance<T>(
        _ value: T,
        _ keyPath: ReferenceWritableKeyPath<UINavigationBarAppearance, T>
    ) {
        customizeBarStandardAppearance(
            value,
            keyPath
        )
        customizeBarCompactAppearance(
            value,
            keyPath
        )
        customizeBarScrollEdgeAppearance(
            value,
            keyPath
        )
    }

    public func customizeBarStandardAppearance<T>(
        _ value: T,
        _ keyPath: ReferenceWritableKeyPath<UINavigationBarAppearance, T>
    ) {
        let appearance = standardAppearance.copy()
        appearance[keyPath: keyPath] = value
        standardAppearance = appearance
    }

    public func customizeBarCompactAppearance<T>(
        _ value: T,
        _ keyPath: ReferenceWritableKeyPath<UINavigationBarAppearance, T>
    ) {
        let appearance = compactAppearance?.copy()
        appearance?[keyPath: keyPath] = value
        compactAppearance = appearance
    }

    public func customizeBarScrollEdgeAppearance<T>(
        _ value: T,
        _ keyPath: ReferenceWritableKeyPath<UINavigationBarAppearance, T>
    ) {
        let appearance = scrollEdgeAppearance?.copy()
        appearance?[keyPath: keyPath] = value
        scrollEdgeAppearance = appearance
    }
}
