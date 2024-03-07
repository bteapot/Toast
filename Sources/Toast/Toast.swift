//
//  Toast.swift
//  Toast
//
//  Created by Денис Либит on 18.08.2020.
//

import Foundation
import UIKit


/// Container for message showing functions.
public struct Toast {}

// MARK: - General-purpose

extension Toast {
    /// Show arbitrary message.
    /// - Parameters:
    ///   - title: Title text.
    ///   - text: Body text.
    ///   - foreground: Color for message text, icon and accessory icon.
    ///   - background: Color for message background.
    ///   - touched: Color for flashing of message background on user's touch.
    ///   - icon: Message icon.
    ///   - accessory: Accessory icon.
    ///   - timeout: Message timeout. Message will have no timeout when `nil`.
    ///   - tap: Closure will be called when user taps on message. When this parameter is `nil`, message title and text will be copied to clipboard.
    public static func show(
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
        DispatchQueue.main.async {
            // get window
            let w = W.get()
            
            // show message
            w.vc.v.show(
                title:      title,
                text:       text,
                foreground: foreground,
                background: background,
                touched:    touched,
                icon:       icon,
                accessory:  accessory,
                timeout:    timeout,
                tap:        tap
            )
        }
    }
}

// MARK: - Info

extension Toast {
    /// Show info message.
    ///
    /// This function takes configuration parameters from ``Config/info`` parameter of ``Config``.
    ///
    /// - Parameters:
    ///   - title: Title text.
    ///   - text: Body text.
    ///   - icon: Message icon. Defaults to value in `Toast.Config.info.icon`.
    ///   - accessory: Accessory icon.
    ///   - timeout: Message timeout. Defaults to value in `Toast.Config.info.timeout`.
    ///   - tap: Closure will be called when user taps on message. When this parameter is `nil`, message title and text will be copied to clipboard.
    public static func info(
        title:      String,
        text:       String,
        icon:       UIImage? = Toast.config.info.icon,
        accessory:  UIImage? = nil,
        timeout:    TimeInterval? = Toast.config.info.timeout,
        tap:        (() -> Void)? = nil
    ) {
        self.show(
            title:      title,
            text:       text,
            foreground: Toast.config.info.foreground,
            background: Toast.config.info.background,
            touched:    Toast.config.info.touched,
            icon:       icon,
            accessory:  accessory,
            timeout:    timeout,
            tap:        tap
        )
    }
}

// MARK: - Error

extension Toast {
    /// Show error message.
    ///
    /// This function takes configuration parameters from ``Config/error`` parameter of ``Config``.
    ///
    /// - Parameters:
    ///   - title: Title text.
    ///   - text: Body text.
    ///   - icon: Message icon. Defaults to value in `Toast.Config.error.icon`.
    ///   - accessory: Accessory icon.
    ///   - timeout: Message timeout. Defaults to value in `Toast.Config.error.timeout`.
    ///   - tap: Closure will be called when user taps on message. When this parameter is `nil`, message title and text will be copied to clipboard.
    public static func error(
        title:      String,
        text:       String,
        icon:       UIImage? = Toast.config.error.icon,
        accessory:  UIImage? = nil,
        timeout:    TimeInterval? = Toast.config.error.timeout,
        tap:        (() -> Void)? = nil
    ) {
        self.show(
            title:      title,
            text:       text,
            foreground: Toast.config.error.foreground,
            background: Toast.config.error.background,
            touched:    Toast.config.error.touched,
            icon:       icon,
            accessory:  accessory,
            timeout:    timeout,
            tap:        tap
        )
    }
}
