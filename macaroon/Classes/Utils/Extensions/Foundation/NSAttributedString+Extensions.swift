// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension NSAttributedString {
    public convenience init(string: String, args: [Args]) {
        var attributes: [Key: Any] = [:]

        args.forEach { arg in
            switch arg {
            case .font(let font):
                if let someFont = font {
                    attributes[.font] = font
                }
            case .textColor(let textColor):
                if let someTextColor = textColor {
                    attributes[.foregroundColor] = someTextColor
                }
            case .underlined(let color):
                attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
                attributes[.underlineColor] = color
            case .letterSpacing(let spacing):
                attributes[.kern] = spacing
            case .paragraphStyle(let paragraphArgs):
                if !paragraphArgs.isEmpty {
                    let paragraphStyle = NSMutableParagraphStyle()

                    paragraphArgs.forEach { pArg in
                        switch pArg {
                        case .lineHeight(let height):
                            paragraphStyle.minimumLineHeight = height
                            paragraphStyle.maximumLineHeight = height
                        case .alignment(let alignment):
                            paragraphStyle.alignment = alignment
                        case .lineBreakMode(let lineBreakMode):
                            paragraphStyle.lineBreakMode = lineBreakMode
                        }
                    }
                    attributes[.paragraphStyle] = paragraphStyle
                }
            }
        }

        self.init(string: string, attributes: attributes)
    }
}

extension NSAttributedString {
    public enum Args {
        case font(UIFont?)
        case textColor(UIColor?)
        case underlined(UIColor?)
        case letterSpacing(CGFloat)
        case paragraphStyle([ParagraphArgs])
    }

    public enum ParagraphArgs {
        case lineHeight(CGFloat)
        case alignment(NSTextAlignment)
        case lineBreakMode(NSLineBreakMode)
    }
}
