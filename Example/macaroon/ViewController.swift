// Copyright © 2019 hipolabs. All rights reserved.

import UIKit
import Macaroon
import SnapKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageSize = CGSize(width: 100.0, height: 100.0)

        let imageView = DownloadableImageView()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.size.equalTo(imageSize)
            maker.center.equalToSuperview()
        }

        if let url = URL(string: "https://qube-staging.s3.amazonaws.com/qube-icons/default_qube_icon.svg") {
//            let layer = CALayer(SVGURL: url) { svgLayer in
//                svgLayer.resizeToFit(CGRect(origin: .zero, size: imageSize))
//                imageView.layer.addSublayer(svgLayer)
//            }
            imageView.load(from: SVGImageSource(url: url, size: imageSize))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
