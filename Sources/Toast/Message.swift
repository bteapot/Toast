//
//  Message.swift
//  Toast
//
//  Created by Денис Либит on 09.03.2022.
//

import Foundation
import UIKit


final class Message: UIView {
    
    // MARK: - Initialization
    
    init(
        title:      String,
        text:       String,
        foreground: UIColor,
        background: UIColor,
        touched:    UIColor,
        icon:       UIImage? = nil,
        accessory:  UIImage? = nil,
        tap:        (() -> Void)? = nil
    ) {
        // parameters
        self.touched = touched
        self.tap = tap
        
        // header label
        self.titleLabel = UILabel(frame: .zero)
        self.titleLabel.numberOfLines = Toast.config.title.maxLines
        self.titleLabel.attributedText =
            NSAttributedString(
                string: title,
                attributes: [
                    .font: Toast.config.title.font,
                    .foregroundColor: foreground,
                    .paragraphStyle: Toast.config.title.paragraph,
                ]
            )
            
        // text label
        self.textLabel = UILabel(frame: .zero)
        self.textLabel.numberOfLines = Toast.config.text.maxLines
        self.textLabel.attributedText =
            NSAttributedString(
                string: text,
                attributes: [
                    .font: Toast.config.text.font,
                    .foregroundColor: foreground,
                    .paragraphStyle: Toast.config.text.paragraph,
                ]
            )
        
        // icon
        self.icon = UIImageView(image: icon)
        self.icon.tintColor = foreground
        
        // accessory icon
        self.accessory = UIImageView(image: accessory)
        self.accessory.tintColor = foreground
        
        // initialization
        super.init(frame: .zero)
        
        // properties
        self.backgroundColor  = background
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius  = Toast.config.cornerRadius
        self.layer.shadowColor   = Toast.config.shadowColor
        self.layer.shadowRadius  = Toast.config.shadowRadius
        self.layer.shadowOpacity = Toast.config.shadowOpacity
        
        // добавим сабвьюхи
        self.addSubview(self.icon)
        self.addSubview(self.titleLabel)
        self.addSubview(self.textLabel)
        self.addSubview(self.accessory)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { abort() }
    
    // MARK: - Window
    
    let w: W? = W.current
    
    // MARK: - Properties
    
    let touched: UIColor
    let tap: (() -> Void)?
    
    // MARK: - Subviews
    
    let titleLabel: UILabel
    let textLabel:  UILabel
    let icon:       UIImageView
    let accessory:  UIImageView
    
    // MARK: - Geometry
    
    private var lastSize: CGSize = .zero
    
    private func layout(with size: CGSize) -> CGFloat {
        // already calculated for that width?
        if size.width == self.lastSize.width {
            // return previously calculated
            return self.lastSize.height
        }
        
        // layout views
        let padding:        CGFloat = Toast.config.contentPadding
        let iconSize:       CGSize  = self.icon.image?.size ?? .zero
        let accessorySize:  CGSize  = self.accessory.image?.size ?? .zero
        let leftInset:      CGFloat = iconSize.width > 0 ? iconSize.width + padding * 2 : padding
        let rightInset:     CGFloat = accessorySize.width > 0 ? accessorySize.width + padding * 2 : padding
        let textWidth:      CGFloat = size.width - leftInset - rightInset
        let titleHeight:    CGFloat = self.titleLabel.sizeThatFits(width: textWidth).height.ceiled()
        let textHeight:     CGFloat = self.textLabel.sizeThatFits(width: textWidth).height.ceiled()
        let spacing:        CGFloat = ceil(Toast.config.title.font.lineHeight * 0.3)
        let height:         CGFloat = max(iconSize.height, accessorySize.height, titleHeight + spacing + textHeight).ceiled() + padding * 2
        
        if self.traitCollection.layoutDirection == .rightToLeft {
            self.icon.frame =
                CGRect(
                    x:      size.width - padding - iconSize.width,
                    y:      padding,
                    width:  iconSize.width,
                    height: iconSize.height
                )
                .ceiled()
            
            self.titleLabel.frame =
                CGRect(
                    x:      rightInset,
                    y:      padding,
                    width:  textWidth,
                    height: titleHeight
                )
                .ceiled()
            
            self.textLabel.frame =
                CGRect(
                    x:      rightInset,
                    y:      padding + titleHeight + spacing,
                    width:  textWidth,
                    height: textHeight
                )
                .ceiled()
            
            self.accessory.frame =
                CGRect(
                    x:      padding,
                    y:      (height - accessorySize.height) / 2,
                    width:  accessorySize.width,
                    height: accessorySize.height
                )
                .ceiled()
        } else {
            self.icon.frame =
                CGRect(
                    x:      padding,
                    y:      padding,
                    width:  iconSize.width,
                    height: iconSize.height
                )
                .ceiled()
            
            self.titleLabel.frame =
                CGRect(
                    x:      leftInset,
                    y:      padding,
                    width:  textWidth,
                    height: titleHeight
                )
                .ceiled()
            
            self.textLabel.frame =
                CGRect(
                    x:      leftInset,
                    y:      padding + titleHeight + spacing,
                    width:  textWidth,
                    height: textHeight
                )
                .ceiled()
            
            self.accessory.frame =
                CGRect(
                    x:      size.width - padding - accessorySize.width,
                    y:      (height - accessorySize.height) / 2,
                    width:  accessorySize.width,
                    height: accessorySize.height
                )
                .ceiled()
        }
        
        // store calculated size
        self.lastSize =
            CGSize(
                width:  size.width,
                height: height
            )
        
        // return result
        return height
    }
    
    override func layoutSubviews() {
        _ = self.layout(with: self.bounds.size)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: self.layout(with: size))
    }
    
    // MARK: - Environment
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.lastSize = .zero
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // call user defined block or just copy message text to clipboard
        if let tap = self.tap {
            tap()
        } else {
            
            UIPasteboard.general.string = [
                self.titleLabel.text,
                self.textLabel.text,
            ]
            .compactMap { $0 }
            .joined(separator: "\n")
        }
        
        // remove message
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.allowUserInteraction],
            animations: {
                self.backgroundColor = self.touched
            },
            completion: { finished in
                if let v = self.superview as? W.VC.V {
                    v.remove(messages: [self])
                }
            }
        )
    }
}
