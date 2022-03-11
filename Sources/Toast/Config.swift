//
//  Config.swift
//  Toast
//
//  Created by Денис Либит on 04.03.2022.
//

import Foundation
import UIKit


extension Toast {
    public struct Config {
        public static var info =
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
        
        public static var error =
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
        
        public static var windowLevel:      UIWindow.Level = .init(rawValue: UIWindow.Level.normal.rawValue + 1)
        public static var insets:           UIEdgeInsets = .init(all: 24)
        public static var maxWidth:         CGFloat = 480
        public static var contentPadding:   CGFloat = 12
        
        public static var cornerRadius:     CGFloat = 8
        public static var shadowColor:      CGColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        public static var shadowRadius:     CGFloat = 4
        public static var shadowOpacity:    Float   = 0.5
        
        public static var titleFont:        UIFont = .preferredFont(forTextStyle: .callout).with(weight: .semibold)
        public static var textFont:         UIFont = .preferredFont(forTextStyle: .footnote)
        public static var maxLines:         Int = 8
        
        public static var titleParagraph: NSMutableParagraphStyle = {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right : .left
            paragraph.lineHeightMultiple = 0.85
            paragraph.paragraphSpacing = Toast.Config.titleFont.lineHeight * 0.15
            paragraph.lineBreakMode = .byTruncatingTail
            return paragraph
        }()
        
        public static var textParagraph: NSMutableParagraphStyle = {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .right : .left
            paragraph.lineHeightMultiple = 0.85
            paragraph.paragraphSpacing = Toast.Config.textFont.lineHeight * 0.15
            paragraph.lineBreakMode = .byTruncatingTail
            paragraph.hyphenationFactor = 1
            return paragraph
        }()
        
        private init() {}
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
