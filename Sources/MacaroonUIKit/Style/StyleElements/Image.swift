// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonResources
import MacaroonUtils
import UIKit

public protocol Image {
    var uiImage: UIImage { get }
}

extension Image {
    public var originalImage: UIImage {
        return uiImage.original
    }

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

public protocol StateImage: Image {
    typealias State = UIControl.State

    var state: State { get }
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

    public init(
        image: Image,
        state: State
    ) {
        self.uiImage = image.uiImage
        self.state = state
    }
}

extension AnyStateImage {
    public static func normal(
        _ image: Image
    ) -> AnyStateImage {
        return AnyStateImage(image: image, state: .normal)
    }

    public static func highlighted(
        _ image: Image
    ) -> AnyStateImage {
        return AnyStateImage(image: image, state: .highlighted)
    }

    public static func selected(
        _ image: Image
    ) -> AnyStateImage {
        return AnyStateImage(image: image, state: .selected)
    }

    public static func disabled(
        _ image: Image
    ) -> AnyStateImage {
        return AnyStateImage(image: image, state: .disabled)
    }
}

public typealias StateImageGroup = [AnyStateImage]

extension StateImageGroup {
    public subscript (
        state: StateImage.State
    ) -> UIImage? {
        return first { $0.state == state }?.uiImage
    }
}
