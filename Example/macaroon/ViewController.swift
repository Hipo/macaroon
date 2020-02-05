// Copyright © 2019 hipolabs. All rights reserved.

import UIKit
import Macaroon
import SnapKit

class ViewController: UIViewController {
    private lazy var polling = Polling(intervalInSeconds: 2.0) { print("Polling") }

    private var isRunning = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let button1 = UIButton()
        button1.backgroundColor = .systemRed
        button1.setTitle("Resume", for: .normal)
        view.addSubview(button1)
        button1.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 100.0, height: 50.0))
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(200.0)
        }

        let button2 = UIButton()
        button2.backgroundColor = .systemRed
        button2.setTitle("Stop", for: .normal)
        view.addSubview(button2)
        button2.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 100.0, height: 50.0))
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(300.0)
        }

        button1.addTarget(self, action: #selector(resume), for: .touchUpInside)
        button2.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }

    @objc
    private func resume() {
        isRunning.toggle()

        if isRunning {
            polling.resume()
        } else {
            polling.pause()
        }
    }

    @objc
    private func cancel() {
        polling.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
