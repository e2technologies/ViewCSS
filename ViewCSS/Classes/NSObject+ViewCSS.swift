/*
 Copyright 2018 Eric Chapman
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this
 software and associated documentation files (the "Software"), to deal in the Software
 without restriction, including without limitation the rights to use, copy, modify,
 merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be included in all copies
 or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
 OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

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
        
        // Store the cache key.  This will be used later to retrieve
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
