//
//  Config.swift
//  Toast
//
//  Created by Денис Либит on 04.03.2022.
//

import Foundation
import UIKit


// MARK: - Публичное

extension Toast {
    public static var config: Config {
        lock.withLock { _config }
    }
    
    public static func set(config: (inout Config) -> Void) {
        lock.withLock {
            config(&_config)
        }
    }
}


// MARK: - Приватное

private extension Toast {
    static var _config = Config()
    static let lock = NSLock()
}

extension Toast {
    public struct Config {
        public var info =
            Scheme(
                foreground: UIColor(
                    light: UIColor(hue: 0.00, saturation: 0.00, brightness: 1.00, alpha: 1.00),
                    dark:  UIColor(hue: 0.00, saturation: 0.00, brightness: 0.15, alpha: 1.00)
                ),
                background: UIColor(
                    light: UIColor(hue: 0.00, saturation: 0.00, brightness: 0.00, alpha: 0.75),
                    dark:  UIColor(hue: 0.00, saturation: 0.00, brightness: 0.85, alpha: 0.95)
                ),
                touched: UIColor(
                    light: UIColor(hue: 0.67, saturation: 0.03, brightness: 0.90, alpha: 1.00),
                    dark:  UIColor(hue: 0.67, saturation: 0.03, brightness: 0.30, alpha: 1.00)
                ),
                icon: UIImage(symbol: "info.circle", size: 24),
                timeout: 3
            )
        
        public var error =
            Scheme(
                foreground: UIColor(hue: 0.00, saturation: 0.00, brightness: 1.00, alpha: 1.00),
                background: UIColor(hue: 0.00, saturation: 0.95, brightness: 0.70, alpha: 0.85),
                touched: UIColor(
                    light: UIColor(hue: 0.67, saturation: 0.03, brightness: 0.90, alpha: 1.00),
                    dark:  UIColor(hue: 0.67, saturation: 0.03, brightness: 0.30, alpha: 1.00)
                ),
                icon: UIImage(symbol: "exclamationmark.triangle", size: 24),
                timeout: 6
            )
        
        public var windowLevel:      UIWindow.Level = .init(rawValue: UIWindow.Level.normal.rawValue + 1)
        public var insets:           UIEdgeInsets = .init(all: 24)
        public var maxWidth:         CGFloat = 480
        public var contentPadding:   CGFloat = 12
        
        public var cornerRadius:     CGFloat = 8
        public var shadowColor:      CGColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        public var shadowRadius:     CGFloat = 4
        public var shadowOpacity:    Float   = 0.5
        
        public var title =
            Label(
                font: .preferredFont(forTextStyle: .callout).with(weight: .semibold),
                maxLines: 2,
                paragraph: {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.alignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right : .left
                    paragraph.lineHeightMultiple = 0.85
                    paragraph.paragraphSpacing = UIFont.preferredFont(forTextStyle: .callout).with(weight: .semibold).lineHeight * 0.15
                    paragraph.lineBreakMode = .byTruncatingTail
                    return paragraph
                }()
            )
        
        public var text =
            Label(
                font: .preferredFont(forTextStyle: .footnote),
                maxLines: 6,
                paragraph: {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.alignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right : .left
                    paragraph.lineHeightMultiple = 0.85
                    paragraph.paragraphSpacing = UIFont.preferredFont(forTextStyle: .footnote).lineHeight * 0.15
                    paragraph.lineBreakMode = .byTruncatingTail
                    paragraph.hyphenationFactor = 1
                    return paragraph
                }()
            )

        fileprivate init() {}
    }
}

extension Toast.Config {
    public struct Scheme {
        public var foreground: UIColor
        public var background: UIColor
        public var touched:    UIColor
        public var icon:       UIImage?
        public var timeout:    TimeInterval?
    }
}

extension Toast.Config {
    public struct Label {
        public var font:      UIFont
        public var maxLines:  Int
        public var paragraph: NSMutableParagraphStyle
    }
}
