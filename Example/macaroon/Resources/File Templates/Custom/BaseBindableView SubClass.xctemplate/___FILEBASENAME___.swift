//___FILEHEADER___

import SnapKit
import UIKit

protocol ___FILEBASENAMEASIDENTIFIER___Delegate: class {
    func <#name#>()
}

class ___FILEBASENAMEASIDENTIFIER___<StyleGuide: ___FILEBASENAMEASIDENTIFIER___StyleGuideConvertible>: BaseView<StyleGuide> {

    // MARK: - Properties

    weak var delegate: ___FILEBASENAMEASIDENTIFIER___Delegate?
    private let layout = Layout<LayoutConstants>().current

    // MARK: - Subviews

    // MARK: - Initializers

    @available(*, unavailable)
    required init(styleGuide: StyleGuide) {
        fatalError("init(styleGuide:) has not been implemented")
    }

    // MARK: - Setup

    override func customizeAppearance(_ styleGuide: StyleGuide) {
        super.customizeAppearance(styleGuide)

    }

    func prepareLayoutHierarcy() {
        super.prepareLayoutHierarcy()

    }

    func prepareLayout() {
        super.prepareLayout()

    }

    func setListeners() {
        super.setListeners()

    }

    func linkInteractors() {
        super.linkInteractors()

    }

    // MARK: - Layout setup

    private func prepare<#name#>ViewLayout() {
        <#name#>.snp.makeConstraints { make in

        }
    }

    // MARK: - Actions

}

// MARK: - Public

extension ___FILEBASENAMEASIDENTIFIER___ {

}

// MARK: - Layout Constants

extension ___FILEBASENAMEASIDENTIFIER___ {
    private struct LayoutConstants: AdaptiveLayoutConstants {

    }
}
