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

public class ViewCSSBorderConfig: ViewCSSBaseConfig {
    
    static let BORDER_RADIUS = "border-radius"
    static let BORDER_WIDTH = "border-width"
    static let BORDER_COLOR = "border-color"
    
    public private(set) var radius: CGFloat?
    public private(set) var width: CGFloat?
    public private(set) var color: UIColor?
    
    static func fromCSS(dict: Dictionary<String, Any>) -> ViewCSSBorderConfig {
        let config = ViewCSSBorderConfig()
        
        config.cssRadius(string: self.checkVariables(string: dict[BORDER_RADIUS] as? String))
        config.cssColor(string: self.checkVariables(string: dict[BORDER_COLOR] as? String))
        config.cssWidth(string: self.checkVariables(string: dict[BORDER_WIDTH] as? String))
        
        return config
    }
    
    static func toCSS(object: Any) -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if let viewProtocol = object as? ViewCSSProtocol {
            let borderRadius = viewProtocol.getCSSBorderRadius()
            let borderColor = viewProtocol.getCSSBorderColor()
            let borderWidth = viewProtocol.getCSSBorderWidth()
            
            if borderRadius > 0 {
                dict[BORDER_RADIUS] = borderRadius.toPX
            }
            
            if borderWidth > 0 && borderColor != nil {
                dict[BORDER_WIDTH] = borderWidth.toPX
                dict[BORDER_COLOR] = borderColor!.toCSS
            }
        }
        
        return dict
    }
    
    private func cssRadius(string: String?) {
        if string != nil {
            if let radius = string!.lengthToFloat {
                self.radius = radius
            }
            
            if self.radius == nil {
                self.printWarning(attribute: type(of: self).BORDER_RADIUS, value: string!)
            }
        }
    }
    
    private func cssColor(string: String?) {
        if string != nil {
            self.color = UIColor(css: string!)
            
            if self.color == nil {
                self.printWarning(attribute: type(of: self).BORDER_COLOR, value: string!)
            }
        }
    }
    
    private func cssWidth(string: String?) {
        if string != nil {
            let trimmedString = string!.trimmingCharacters(in: .whitespaces)
            
            if let length = trimmedString.lengthToFloat {
                self.width = length
            }
            else {
                switch trimmedString {
                case "medium":
                    self.width = 2
                case "thin":
                    self.width = 1
                case "thick":
                    self.width = 3
                default:
                    self.width = nil
                }
            }
            
            if self.width == nil {
                self.printWarning(attribute: type(of: self).BORDER_WIDTH, value: string!)
            }
        }
    }
}
