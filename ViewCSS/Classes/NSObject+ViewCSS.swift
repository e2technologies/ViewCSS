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
            
            // If we are snooping, generate the CSS dictionary
            if ViewCSSManager.shared.snoop && klass != nil {
                let cssDict = ViewCSSConfig.toCSS(object: target)
                let keyName = className + "." + klass!
                ViewCSSManager.shared.logSnoop(key: keyName, dict: cssDict)
            }
        }
    }
}
