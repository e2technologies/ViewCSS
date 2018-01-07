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

public extension NSObject {

    // ================================================================
    // CSS Methods
    // ================================================================
    
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
        if let target = (object ?? self) as? UIView {
            target.css(className: className, class: klass, style: style, custom: custom)
            
            // Check if there is a defined custom CSS method
            if let customizeProtocol = self as? ViewCSSCustomizableProtocol {
                let config = target.cssConfig(class: klass, style: style)
                customizeProtocol.cssCustomize(object: object, class: klass, style: style, config: config)
            }
        }
    }
    
    // ================================================================
    // CSS Config Methods
    // ================================================================
    
    func cssConfig(style: String?) -> ViewCSSConfig {
        return self.cssConfig(class: nil, style: style)
    }
    
    func cssConfig(class klass: String?) -> ViewCSSConfig {
        return self.cssConfig(class: klass, style: nil)
    }
    
    func cssConfig(class klass: String?, style: String?) -> ViewCSSConfig {
        let cssManager = ViewCSSManager.shared
        let className = cssManager.getClassName(object: self)
        return cssManager.getConfig(className: className, class: klass, style: style)
    }
    
    // ================================================================
    // CSS Class Config Methods
    // ================================================================
    
    class func cssConfig(style: String?) -> ViewCSSConfig {
        return self.cssConfig(class: nil, style: style)
    }
    
    class func cssConfig(class klass: String?) -> ViewCSSConfig {
        return self.cssConfig(class: klass, style: nil)
    }
    
    class func cssConfig(class klass: String?, style: String?) -> ViewCSSConfig {
        let cssManager = ViewCSSManager.shared
        let className = cssManager.getClassName(class: self)
        return cssManager.getConfig(className: className, class: klass, style: style)
    }
    
    // ================================================================
    // CSS Scale Properties
    // ================================================================
    
    var cssScale: CGFloat {
        return ViewCSSAutoScaleCache.shared.scale
    }
    
    class var cssScale: CGFloat {
        return ViewCSSAutoScaleCache.shared.scale
    }
    
    // ================================================================
    // Get attributed text
    // ================================================================
    
    public static func generateCSSText(parentClassName: String?, parentClass: String?,
                                       parentStyle: String?, text: String?) -> NSAttributedString? {
        return ViewCSSManager.shared.generateAttributedString(
            parentClassName: parentClassName,
            parentClass: parentClass,
            parentStyle: parentStyle,
            text: text)
    }
    
    public static func generateCSSText(parentClass: String?, parentStyle: String?, text: String?) -> NSAttributedString? {
        return self.generateCSSText(
            parentClassName: ViewCSSManager.shared.getClassName(class: self),
            parentClass: parentClass,
            parentStyle: parentStyle,
            text: text)
    }
    
    public static func generateCSSText(parentStyle: String?, text: String?) -> NSAttributedString? {
        return self.generateCSSText(
            parentClass: nil,
            parentStyle: parentStyle,
            text: text)
    }
    
    public static func generateCSSText(parentClass: String?, text: String?) -> NSAttributedString? {
        return self.generateCSSText(
            parentClass: parentClass,
            parentStyle: nil,
            text: text)
    }
    
    public static func generateCSSText(text: String?) -> NSAttributedString? {
        return self.generateCSSText(
            parentClass: nil,
            parentStyle: nil,
            text: text)
    }
}
