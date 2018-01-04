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

public class ViewCSSShadowConfig: ViewCSSBaseConfig {
    static let SHADOW = "shadow"
    static let SHADOW_OPACITY = "shadow-opacity"
    static let OPACITY_DEFAULT: CGFloat = 1.0
    
    private var base: String?
    public private(set) var offset: CGSize?
    public private(set) var radius: CGFloat?
    public private(set) var color: UIColor?
    public private(set) var opacity: CGFloat?
    
    private class func getParam(_ param: String, base: String?=nil) -> String {
        if base != nil {
            return base! + "-" + param
        }
        return param
    }
    
    private func getParam(_ param: String) -> String {
        return type(of: self).getParam(param, base: self.base)
    }
    
    func setAll(dict: Dictionary<String, Any>) {
        let string = dict[self.getParam(type(of: self).SHADOW)] as? String
        
        if string != nil {
            let shadowComponents = string!.split(separator: " ")
            
            // Get the horizontal and vertial offsets
            if shadowComponents.count >= 2 {
                let hShadow = self.valueFromString(String(shadowComponents[0]),
                                                   types: [.length],
                                                   match: nil) as? CGFloat
                let vShadow = self.valueFromString(String(shadowComponents[1]),
                                                   types: [.length],
                                                   match: nil) as? CGFloat
                if hShadow != nil && vShadow != nil {
                    self.offset = CGSize(width: hShadow!, height: vShadow!)
                    self.opacity = type(of: self).OPACITY_DEFAULT
                }
                else {
                    self.printWarning(attribute: self.getParam(type(of: self).SHADOW), value: string!)
                    return
                }
            }
            
            // Check for a radius
            var index = 2;
            if shadowComponents.count > index {
                if let radius = self.valueFromString(String(shadowComponents[index]),
                                                     types: [.length],
                                                     match: nil) as? CGFloat {
                    self.radius = radius
                    index += 1
                }
            }
            
            // Check for color
            if shadowComponents.count > index {
                if let color = self.valueFromString(String(shadowComponents[index]),
                                                    types: [.color],
                                                    match: nil) as? UIColor {
                    self.color = color
                }
            }
        }
    }
    
    func setOpacity(dict: Dictionary<String, Any>) {
        if let opacity = self.valueFromDict(dict,
                                            attribute: self.getParam(type(of: self).SHADOW_OPACITY),
                                            types:[.number],
                                            match: nil) as? CGFloat {
            self.opacity = opacity
        }
    }
    
    static func fromCSS(dict: Dictionary<String, Any>, base: String?=nil) -> ViewCSSShadowConfig {
        let config = ViewCSSShadowConfig()
        
        config.base = base
        config.setAll(dict: dict)
        config.setOpacity(dict: dict)
  
        return config
    }
    
    static func toCSS(object: Any, base: String?=nil) -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if let shadowProtocol = object as? ViewCSSShadowProtocol {
            
            let opacity = shadowProtocol.getCSSShadowOpacity()
            
            // Check for opacity
            if opacity > 0 {
                var shadow = ""
                
                // Print the offset
                if let offset = shadowProtocol.getCSSShadowOffset() {
                    shadow = offset.width.toPX + " " + offset.height.toPX
                }
                
                // Print the radius
                let radius = shadowProtocol.getCSSShadowRadius()
                if radius > 0.0 {
                    shadow += " " + radius.toPX
                }
                
                // Print the color
                if let color = shadowProtocol.getCSSShadowColor() {
                    shadow += " " + color.toCSS
                }
                
                dict[self.getParam(SHADOW, base: base)] = shadow
                
                // Opacity defaults to 1.0.  Explicitely print it if it is different
                if opacity != OPACITY_DEFAULT {
                    dict[self.getParam(SHADOW_OPACITY, base: base)] = opacity.toCSS
                }
            }
        }
        
        return dict
    }
}
