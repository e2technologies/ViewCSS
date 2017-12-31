//
//  UIView+ViewCSS.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/29/17.
//

import Foundation

public protocol ViewCSSCustomizableProtocol {
    func cssCustomize(config: ViewCSSConfig)
}

protocol ViewCSSProtocol {
    func setCSSBackgroundColor(_ color: UIColor)
    func setCSSTintColor(_ color: UIColor)
    func setCSSBorderRadius(_ radius: CGFloat)
    func setCSSBorder(width: CGFloat, color: UIColor)
    func setCSSOpacity(_ opacity: CGFloat)
}

protocol ViewCSSTextProtocol: ViewCSSProtocol {
    func setCSSTextColor(_ color: UIColor)
    func setCSSFont(_ font: UIFont)
    func setCSSTextAlignment( _ alignment: NSTextAlignment)
}

extension UIView: ViewCSSProtocol {
    func setCSSBackgroundColor(_ color: UIColor) { self.backgroundColor = color }
    func setCSSTintColor(_ color: UIColor) { self.tintColor = color }
    func setCSSBorderRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    func setCSSBorder(width: CGFloat, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    func setCSSOpacity(_ opacity: CGFloat) { self.alpha = opacity }
}

extension UILabel: ViewCSSTextProtocol {
    func setCSSTextColor(_ color: UIColor) { self.textColor = color }
    func setCSSFont(_ font: UIFont) { self.font = font }
    func setCSSTextAlignment( _ alignment: NSTextAlignment) { self.textAlignment = alignment }
}

extension UITextField: ViewCSSTextProtocol {
    func setCSSTextColor(_ color: UIColor) { self.textColor = color }
    func setCSSFont(_ font: UIFont) { self.font = font }
    func setCSSTextAlignment( _ alignment: NSTextAlignment) { self.textAlignment = alignment }
}

extension UITextView: ViewCSSTextProtocol {
    func setCSSTextColor(_ color: UIColor) { self.textColor = color }
    func setCSSFont(_ font: UIFont) { self.font = font }
    func setCSSTextAlignment( _ alignment: NSTextAlignment) { self.textAlignment = alignment }
}

extension UIButton: ViewCSSTextProtocol {
    func setCSSTextColor(_ color: UIColor) { self.setTitleColor(color, for: .normal) }
    func setCSSFont(_ font: UIFont) { self.titleLabel?.font = font }
    func setCSSTextAlignment( _ alignment: NSTextAlignment) {
        if alignment == .left {
            self.contentHorizontalAlignment = .left
        }
        else if alignment == .right {
            self.contentHorizontalAlignment = .right
        }
        else {
            self.contentHorizontalAlignment = .center
        }
    }
}

private var CSSKeyObjectHandle: UInt8 = 0
public extension NSObject {
    
    private var cssKey: String? {
        get {
            return objc_getAssociatedObject(self, &CSSKeyObjectHandle) as? String
        }
        set {
            objc_setAssociatedObject(self, &CSSKeyObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func css(custom: ((ViewCSSConfig) -> Void)?=nil) {
        self.css(object: nil, class: nil, style: nil, custom: custom)
    }
    
    func css(style: String?, custom: ((ViewCSSConfig) -> Void)?=nil) {
        self.css(object: nil, class: nil, style: style, custom: custom)
    }
    
    func css(class klass: String?, custom: ((ViewCSSConfig) -> Void)?=nil) {
        self.css(object: nil, class: klass, style: nil, custom: custom)
    }
    
    func css(class klass: String?, style: String?, custom: ((ViewCSSConfig) -> Void)?=nil) {
        self.css(object: nil, class: klass, style: style, custom: custom)
    }
    
    func css(object: Any?, custom: ((ViewCSSConfig) -> Void)?=nil) {
        self.css(object: object, class: nil, style: nil, custom: custom)
    }
    
    func css(object: Any?, style: String?, custom: ((ViewCSSConfig) -> Void)?=nil) {
        self.css(object: object, class: nil, style: style, custom: custom)
    }
    
    func css(object: Any?, class klass: String?, custom: ((ViewCSSConfig) -> Void)?=nil) {
        self.css(object: object, class: klass, style: nil, custom: custom)
    }

    func css(object: Any?, class klass: String?, style: String?, custom: ((ViewCSSConfig) -> Void)?=nil) {
        let className = ViewCSSManager.shared.getClassName(object: self)
        if let target = (object ?? self) as? NSObject {
            target.css(className: className, class: klass, style: style, custom: custom)
        }
    }
    
    private func css(className: String, class klass: String?, style: String?, custom: ((ViewCSSConfig) -> Void)?=nil) {
        // Set the style for this object
        self.cssKey = ViewCSSManager.shared.getCacheKey(className: className, style: style, class: klass)
        let config = ViewCSSManager.shared.getConfig(className: className, style: style, class: klass)
        
        // If it is a UIView, check for main color first, else just background color
        if let viewProtocol = self as? ViewCSSProtocol {
            if let color = config.background?.color {
                viewProtocol.setCSSBackgroundColor(color)
            }
            
            if let color = config.tintColor {
                viewProtocol.setCSSTintColor(color)
            }
            
            if let opacity = config.opacity {
                viewProtocol.setCSSOpacity(opacity)
            }
            
            // BORDER
            if let radius = config.border?.radius {
                viewProtocol.setCSSBorderRadius(radius)
            }
            
            if let width = config.border?.width {
                if let color = config.border?.color {
                    viewProtocol.setCSSBorder(width: width, color: color)
                }
            }
        }
        
        // Check if it responds to text protocol
        if let textProtocol = self as? ViewCSSTextProtocol {
            // Set the color
            if config.color != nil {
                textProtocol.setCSSTextColor(config.color!)
            }
            
            // Set the font
            if let font = config.font?.getFont() {
                textProtocol.setCSSFont(font)
            }
            
            // Set the alignment
            if let align = config.text?.align {
                textProtocol.setCSSTextAlignment(align)
            }
        }
        
        // Call the custom config callback
        if custom != nil {
            custom!(config)
        }
        
        // Check if there is a defined cusomt CSS method
        if let customizeProtocol = self as? ViewCSSCustomizableProtocol {
            customizeProtocol.cssCustomize(config: config)
        }
    }

    func getCSS() -> ViewCSSConfig? {
        if let cacheKey = self.cssKey {
            return ViewCSSManager.shared.getConfig(cacheKey: cacheKey)
        }
        return nil
    }
    
}
