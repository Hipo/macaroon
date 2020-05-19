// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol PhotoViewModelConvertible: ViewModelConvertible {
    var photo: ImageSource? { get set }
    var hasSomePhoto: Bool { get set }

    var size: ImageSize { get }
    var shape: ImageShape { get }
    var placeholder: ImagePlaceholder { get }
}

extension PhotoViewModelConvertible {
    public func getPhoto() -> ImageSource? {
        return photo
    }

    public func hasPhoto() -> Bool {
        return hasSomePhoto
    }
}

extension PhotoViewModelConvertible {
    public mutating func setPhoto(_ url: URL?) {
        photo = PNGImageSource(
            url: url,
            size: size,
            shape: shape,
            placeholder: (photo as? AssetImageSource).unwrap(either: { ImagePlaceholder(source: $0) }, or: placeholder)
        )
    }

    public mutating func setHasSomePhoto(_ url: URL?) {
        hasSomePhoto = url != nil
    }
}

extension PhotoViewModelConvertible {
    public mutating func setPhoto(_ photo: Photo) {
        let size = self.size.reduce() ?? .zero
        let resizedImage = photo.image.resized(size, .aspectFit)
        let fitImage = resizedImage?.cropped(resizedImage?.size.minSquare)
        let scale = fitImage.unwrap(either: { min($0.size.width / size.width, $0.size.height / size.height) }, or: 1.0)
        self.photo = AssetImageSource(asset: fitImage?.shaped(shape, nil, scale))
    }

    public mutating func setHasSomePhoto(_ photo: Photo) {
        hasSomePhoto = true
    }
}
