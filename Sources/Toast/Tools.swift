//
//  Tools.swift
//  
//
//  Created by Денис Либит on 04.03.2022.
//

import Foundation
import CoreGraphics
import UIKit


extension UIFont {
    func with(weight: UIFont.Weight) -> UIFont {
        return UIFont(
            descriptor: self.fontDescriptor.addingAttributes([
                .traits: [
                    UIFontDescriptor.TraitKey.weight: weight,
                ],
            ]),
            size: self.pointSize
        )
    }
}

extension CGFloat {
    func ceiled()  -> CGFloat {
        return ceil(self)
    }
}

extension CGRect {
    func ceiled() -> CGRect {
        CGRect(
            x:      floor(self.minX),
            y:      floor(self.minY),
            width:  ceil(self.width),
            height: ceil(self.height)
        )
    }
}

extension UIEdgeInsets {
    init(
        all:    CGFloat = 0,
        top:    CGFloat? = nil,
        left:   CGFloat? = nil,
        bottom: CGFloat? = nil,
        right:  CGFloat? = nil
    ) {
        self.init(
            top:    top    ?? all,
            left:   left   ?? all,
            bottom: bottom ?? all,
            right:  right  ?? all
        )
    }
}

extension UIView {
    func sizeThatFits(width: CGFloat) -> CGSize {
        return self.sizeThatFits(CGSize(width: width, height: 0))
    }
}

extension UIColor {
    convenience init(light: UIColor, dark:  UIColor) {
        self.init(dynamicProvider: { (provider: UITraitCollection) -> UIColor in
            switch provider.userInterfaceStyle {
            case .unspecified:      return light
            case .light:            return light
            case .dark:              return dark
            @unknown default:       return light
            }
        })
    }
}

public extension UIImage {
    convenience init?(symbol: String, size: CGFloat? = nil, weight: UIImage.SymbolWeight = .medium) {
        #if DEBUG
        if UIImage(systemName: symbol) == nil {
            NSLog("no such symbol: \(symbol)")
            raise(SIGINT)
        }
        #endif
        
        if let size = size {
            self.init(
                systemName: symbol,
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: size,
                    weight: weight
                )
            )
        } else {
            self.init(
                systemName: symbol,
                withConfiguration: UIImage.SymbolConfiguration(
                    weight: weight
                )
            )
        }
    }
}
