//
//  Infrastructure.swift
//  Toast
//
//  Created by Денис Либит on 09.03.2022.
//

import Foundation
import UIKit


// MARK: - Window

final class W: UIWindow {
    required init() {
        Self.captureStatusBarStyle()
        super.init(windowScene: UIWindowScene.active)
        self.windowLevel = Toast.Config.windowLevel
        self.rootViewController = VC()
        self.isHidden = false
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    static weak var current: W?
    
    static func get() -> W {
        return W.current ?? {
            let w = W()
            W.current = w
            return w
        }()
    }
    
    var vc: VC { self.rootViewController as! VC }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.vc.v.hitTest(self.vc.v.convert(point, from: self), with: event)
    }
    
    static var statusBarStyle: UIStatusBarStyle = .default
    
    private static func captureStatusBarStyle() {
        Self.statusBarStyle = {
            // modern variant?
            if let style = UIWindowScene.active.statusBarManager?.statusBarStyle {
                return style
            }
            
            if  let window = UIWindowScene.active.windows.first(where: { $0.isKeyWindow }),
                let root = window.rootViewController
            {
                let vc = root.childForStatusBarStyle ?? root
                return vc.preferredStatusBarStyle
            }
            
            return .default
        }()
    }
}

// MARK: - View Controller

extension W {
    final class VC: UIViewController {
        override func loadView() {
            self.view = V(frame: UIScreen.main.bounds)
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return W.statusBarStyle
        }
        
        var v: V { self.view as! V }
    }
}

// MARK: - View

extension W.VC {
    final class V: UIView {
        
        // MARK: - Layout
        
        override func layoutSubviews() {
            let bounds:     CGRect  = self.bounds.inset(by: self.safeAreaInsets).inset(by: Toast.Config.insets)
            let gap:        CGFloat = Toast.Config.contentPadding
            let width:      CGFloat = min(bounds.width, Toast.Config.maxWidth)
            var top:        CGFloat = bounds.origin.y
            
            self.subviews.reversed().forEach { view in
                view.frame =
                    CGRect(
                        x:      bounds.origin.x + (bounds.width - width) / 2,
                        y:      top,
                        width:  width,
                        height: view.sizeThatFits(width: width).height
                    )
                    .ceiled()
                
                top += view.frame.height + ceil(gap)
            }
        }
        
        // MARK: - Touches
        
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            // message touched?
            for message in self.messages {
                if message.frame.contains(point) {
                    return message
                }
            }
            
            // empty area touched, remove all messages
            self.removeVisible()
            
            // pass touch further
            return nil
        }
        
        // MARK: - Messages
        
        var messages: [Message] { self.subviews as! [Message] }
        
        func show(
            title:      String,
            text:       String,
            foreground: UIColor,
            background: UIColor,
            touched:    UIColor,
            icon:       UIImage? = nil,
            accessory:  UIImage? = nil,
            timeout:    TimeInterval? = nil,
            tap:        (() -> Void)? = nil
        ) {
            // make message view
            let message =
                Message(
                    title:      title,
                    text:       text,
                    foreground: foreground,
                    background: background,
                    touched:    touched,
                    icon:       icon,
                    accessory:  accessory,
                    tap:        tap
                )
            
            // duplicate of one of the already shown?
            if let previous = self.messages.first(where: {
                $0.titleLabel.text       == message.titleLabel.text &&
                $0.textLabel.text        == message.textLabel.text &&
                $0.titleLabel.textColor  == message.titleLabel.textColor &&
                $0.layer.backgroundColor == message.layer.backgroundColor &&
                $0.icon.image            == message.icon.image &&
                $0.accessory.image       == message.accessory.image
            }) {
                self.bringSubviewToFront(previous)
                UIView.animate(
                    withDuration: 0.25,
                    delay: 0,
                    options: [.allowUserInteraction, .curveEaseOut],
                    animations: {
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                    },
                    completion: nil
                )
                return
            }
            
            // pre-animation position
            let bounds: CGRect  = self.bounds.inset(by: self.safeAreaInsets).inset(by: Toast.Config.insets)
            let width:  CGFloat = min(bounds.width, Toast.Config.maxWidth)
            let height: CGFloat = message.sizeThatFits(width: width).height
            
            message.frame =
                CGRect(
                    x:      bounds.origin.x + (bounds.width - width) / 2,
                    y:      self.bounds.origin.y - height,
                    width:  width,
                    height: height
                )
            
            // add subview
            self.addSubview(message)
            
            // show
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: [.allowUserInteraction, .curveEaseOut],
                animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                },
                completion: nil
            )
            
            
            // has timeout?
            if let timeout = timeout, timeout > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + timeout + 0.25) { [weak self, weak message] in
                    if let self = self, let message = message {
                        self.remove(messages: [message])
                    }
                }
            }
        }
        
        func remove(messages: [Message]) {
            // remove specified and layout remaining
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: [.allowUserInteraction],
                animations: {
                    messages.forEach { $0.alpha = 0 }
                },
                completion: { finished in
                    messages.forEach { $0.removeFromSuperview() }
                    
                    // is there still messages remaining?
                    if self.subviews.count > 0 {
                        // there are
                        UIView.animate(
                            withDuration: 0.25,
                            delay: 0,
                            options: [.allowUserInteraction],
                            animations: {
                                self.setNeedsLayout()
                                self.layoutIfNeeded()
                            },
                            completion: nil
                        )
                    } else {
                        // no messages remaining, remove window
                        W.current = nil
                    }
                }
            )
        }
        
        func removeVisible() {
            self.remove(messages: self.messages.filter({ self.bounds.contains($0.frame) }))
        }
    }
}

// MARK: - Window Scene

private extension UIWindowScene {
    static var active: UIWindowScene {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first!
    }
}
