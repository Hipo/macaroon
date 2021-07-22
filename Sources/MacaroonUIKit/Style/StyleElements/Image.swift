// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonResources
import MacaroonUtils
import UIKit

public protocol Image {
    var uiImage: UIImage { get }
}

extension Image {
    public var templateImage: UIImage {
        return uiImage.template
    }
}

extension Image
where
    Self: RawRepresentable,
    Self.RawValue == String {
    public var uiImage: UIImage {
        return rawValue.uiImage
    }
}

extension UIImage: Image {
    public var uiImage: UIImage {
        return self
    }
}

extension String: Image {
    public var uiImage: UIImage {
        return img(self)
    }
}

public protocol StateImage:
    Image,
    Hashable {
    typealias State = UIControl.State

    var state: State { get }
}

extension StateImage {
    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(state.rawValue)
    }
}

public struct AnyStateImage: StateImage {
    public let uiImage: UIImage
    public let state: State

    public init<T: StateImage>(
        _ base: T
    ) {
        self.uiImage = base.uiImage
        self.state = base.state
    }
}

extension AnyStateImage {
    public static func normal(
        _ image: Image
    ) -> AnyStateImage {
        return AnyStateImage(
            NormalImage(image: image)
        )
    }

    public static func highlighted(
        _ image: Image
    ) -> AnyStateImage {
        return AnyStateImage(
            HighlightedImage(image: image)
        )
    }

    public static func selected(
        _ image: Image
    ) -> AnyStateImage {
        return AnyStateImage(
            SelectedImage(image: image)
        )
    }

    public static func disabled(
        _ image: Image
    ) -> AnyStateImage {
        return AnyStateImage(
            DisabledImage(image: image)
        )
    }
}

public struct NormalImage: StateImage {
    public let uiImage: UIImage
    public var state: State = .normal

    public init(
        image: Image
    ) {
        self.uiImage = image.uiImage
    }
}

public struct HighlightedImage: StateImage {
    public let uiImage: UIImage
    public var state: State = .highlighted

    public init(
        image: Image
    ) {
        self.uiImage = image.uiImage
    }
}

public struct SelectedImage: StateImage {
    public let uiImage: UIImage
    public var state: State = .selected

    public init(
        image: Image
    ) {
        self.uiImage = image.uiImage
    }
}

public struct DisabledImage: StateImage {
    public let uiImage: UIImage
    public var state: State = .disabled

    public init(
        image: Image
    ) {
        self.uiImage = image.uiImage
    }
}

public typealias ImageGroup = Set<AnyStateImage>

extension ImageGroup {
    public subscript (
        state: AnyStateImage.State
    ) -> UIImage? {
        return first { $0.state == state }?.uiImage
    }
}
