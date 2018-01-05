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
        
        config.setRadius(dict: dict)
        config.setColor(dict: dict)
        config.setWidth(dict: dict)
        
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
    
    func setRadius(dict: Dictionary<String, Any>) {
        self.radius = self.valueFromDict(
            dict,
            attribute: type(of: self).BORDER_RADIUS,
            types: [.length],
            match: nil) as? CGFloat
    }
    
    func setColor(dict: Dictionary<String, Any>) {
        self.color = self.valueFromDict(
            dict,
            attribute: type(of: self).BORDER_COLOR,
            types: [.color],
            match: nil) as? UIColor
    }
    
    func setWidth(dict: Dictionary<String, Any>) {
        self.width = self.valueFromDict(
            dict,
            attribute: type(of: self).BORDER_WIDTH,
            types: [.length, .custom],
            match: nil,
            custom: { (string: String) in
                if string == "medium" { return 2 }
                else if string == "thin" { return 1 }
                else if string == "thick" { return 3 }
                return nil
            }) as? CGFloat
    }
}
