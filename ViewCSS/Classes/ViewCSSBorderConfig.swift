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
    
    public private(set) var radius: CGFloat?
    public private(set) var width: CGFloat?
    public private(set) var color: UIColor?
    
    init(css: Dictionary<String, Any>) {
        super.init()
        
        self.radius = self.valueFromCSS(
            css, attribute: BORDER_RADIUS, types: [.length], match: nil) as? CGFloat
    
        self.color = self.valueFromCSS(
            css, attribute: BORDER_COLOR, types: [.color], match: nil) as? UIColor
        
        self.width = self.valueFromCSS(
            css, attribute: BORDER_WIDTH, types: [.length, .custom], match: nil,
            custom: { (string: String) in
                if string == "medium" { return CGFloat(2) }
                else if string == "thin" { return CGFloat(1) }
                else if string == "thick" { return CGFloat(3) }
                return nil
        }) as? CGFloat
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
}
