// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Photos
import UIKit

protocol Media { }

public struct Photo: Media {
    public let image: UIImage
    public let url: URL?
    public let asset: PHAsset?
}
