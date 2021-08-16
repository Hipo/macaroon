// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

/// <src>
/// https://stackoverflow.com/questions/72768/how-do-you-detect-credit-card-type-based-on-number

public struct CreditCardTypeDetector {
    private let availableTypes: [CreditCardType] = [
        .visa,
        .masterCard
    ]

    public init() {}

    public func match(
        _ text: String?
    ) -> CreditCardType {
        return
            availableTypes.first {
                RegexValidator(regex: $0.regex)
                    .validate(
                        text
                    ).isSuccess
            } ?? .unknown
    }
}

public enum CreditCardType: String {
    case visa = #"^4[0-9]{0,}$"#
    case masterCard = #"^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[01]|2720)[0-9]{0,}$"#
    case unknown
}

extension CreditCardType {
    var regex: String {
        return rawValue
    }
}
