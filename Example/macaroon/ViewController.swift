// Copyright © 2019 hipolabs. All rights reserved.

import UIKit
import Macaroon
import SnapKit

class ViewController: UIViewController {
    private lazy var v = V()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(v.t!.layoutConstraints)
    }
}

class V: UIView {
    public var t: Constraint?

    private lazy var sub = UIView()
    private lazy var sub2 = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(sub)
        addSubview(sub2)
        sub.snp.makeConstraints {
            t = $0.top == 10 + 10 ~ .defaultHigh
            $0.top == snp.top + 10
            $0.width == snp.width * 0.2
            $0.top == sub2.snp.bottom ~ .defaultLow
            $0.width == snp.width ~ .defaultLow
            $0.bottom == sub2.snp.leading * 0.5 + 10 ~ .defaultLow
            $0.leading >= 10
            $0.trailing <= 20 ~ .fittingSizeLevel
            $0.width == sub2 ~ .defaultLow

            $0.setPaddings(
                (10, 20, 30, 40)
            )
            $0.setPaddings(
                (10 ~ .defaultHigh, 20 ~ .required, 30 ~ .custom(501), 40 ~ .required)
            )
            $0.center(
                offset: (10, 10)
            )
            $0.centerHorizontally(
                offset: 10,
                verticalPaddings: (10, 10)
            )
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
