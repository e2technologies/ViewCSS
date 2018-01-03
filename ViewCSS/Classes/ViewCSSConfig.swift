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

public class ViewCSSConfig: ViewCSSBaseConfig {
    
    // Supported Tags
    static let TINT_COLOR = "tint-color"
    static let COLOR = "color"
    static let OPACITY = "opacity"

    public private(set) var font: ViewCSSFontConfig?
    public private(set) var border: ViewCSSBorderConfig?
    public private(set) var text: ViewCSSTextConfig?
    public private(set) var background: ViewCSSBackgroundConfig?
    public private(set) var tintColor: UIColor?
    public private(set) var color: UIColor?
    public private(set) var opacity: CGFloat?
    
    static func fromCSS(dict: Dictionary<String, Any>) -> ViewCSSConfig {
        let config = ViewCSSConfig()
        
        config.border = ViewCSSBorderConfig.fromCSS(dict: dict)
        config.font = ViewCSSFontConfig.fromCSS(dict: dict)
        config.text = ViewCSSTextConfig.fromCSS(dict: dict)
        config.background = ViewCSSBackgroundConfig.fromCSS(dict: dict)
        config.cssTintColor(string: self.checkVariables(string: dict[TINT_COLOR] as? String))
        config.cssColor(string: self.checkVariables(string: dict[COLOR] as? String))
        config.cssOpacity(string: self.checkVariables(string: dict[OPACITY] as? String))
        
        return config
    }
    
    static func toCSS(object: Any) -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if let viewProtocol = object as? ViewCSSProtocol {
            if let tintColor = viewProtocol.getCSSTintColor() {
                let tintColorCSS = tintColor.toCSS
                // Ignore Apple default
                if tintColorCSS != "#007AFFFF" {
                    dict[TINT_COLOR] = tintColorCSS
                }
            }
            let opacity = viewProtocol.getCSSOpacity()
            if opacity < 1.0 {
                dict[OPACITY] = String(format:"%f", opacity)
            }
        }
        
        if let textProtocol = object as? ViewCSSTextProtocol {
            if let color = textProtocol.getCSSTextColor() {
                dict[COLOR] = color.toCSS
            }
        }
        
        dict.merge(ViewCSSBackgroundConfig.toCSS(object: object), uniquingKeysWith: { (current, _) in current })
        dict.merge(ViewCSSFontConfig.toCSS(object: object), uniquingKeysWith: { (current, _) in current })
        dict.merge(ViewCSSBorderConfig.toCSS(object: object), uniquingKeysWith: { (current, _) in current })
        dict.merge(ViewCSSTextConfig.toCSS(object: object), uniquingKeysWith: { (current, _) in current })
        
        return dict
    }
    
    private func cssTintColor(string: String?) {
        if string != nil {
            self.tintColor = UIColor(css: string!)
            
            if self.tintColor == nil {
                self.printWarning(attribute: type(of: self).TINT_COLOR, value: string!)
            }
        }
    }
    
    private func cssColor(string: String?) {
        if string != nil {
            self.color = UIColor(css: string!)
            
            if self.color == nil {
                self.printWarning(attribute: type(of: self).COLOR, value: string!)
            }
        }
    }
    
    private func cssOpacity(string: String?) {
        if string != nil {
            if let number = string!.numberToFloat {
                self.opacity = number
            }
            
            if self.opacity == nil {
                self.printWarning(attribute: type(of: self).OPACITY, value: string!)
            }
        }
    }
}

