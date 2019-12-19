//___FILEHEADER___

import SnapKit
import UIKit

class ___FILEBASENAMEASIDENTIFIER___<StyleGuide: ___FILEBASENAMEASIDENTIFIER___StyleGuideConvertible>: BaseView<StyleGuide> {

    // MARK: - Properties

    private let layout = Layout<LayoutConstants>().current
    
    // MARK: - Subviews

    <#subviews#>

    // MARK: - Initializers

    init(
        launchArgs: VCLaunchArgs,
        <#args#>
    ) {
        self.<#property#> = <#property#>
        super.init(launchArgs: launchArgs)
    }

    // MARK: - Setup

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

    @objc
    private func <#name#>() {

    }
}

// MARK: - Public

extension ___FILEBASENAMEASIDENTIFIER___ {

}

// MARK: - Layout Constants

extension ___FILEBASENAMEASIDENTIFIER___ {
    private struct LayoutConstants: AdaptiveLayoutConstants {

    }
}
