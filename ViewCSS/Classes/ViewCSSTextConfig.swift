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

public class ViewCSSTextConfig: ViewCSSBaseConfig {
    
    static let TEXT_ALIGN = "text-align"
    
    public private(set) var align: NSTextAlignment?
    public private(set) var shadow: ViewCSSShadowConfig?
    
    static func fromCSS(dict: Dictionary<String, Any>) -> ViewCSSTextConfig {
        let config = ViewCSSTextConfig()
        
        config.shadow = ViewCSSShadowConfig.fromCSS(dict: dict, base: "text")
        config.setAlign(dict: dict)
        
        return config
    }
    
    static func toCSS(object: Any) -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if let textProtocol = object as? ViewCSSTextProtocol {
            var align: String? = nil
            switch textProtocol.getCSSTextAlignment() {
            case .center:
                align = "center"
            case .left:
                align = "left"
            case .right:
                align = "right"
            case .justified:
                align = "justify"
            default:
                align = nil
            }
            if align != nil {
                dict[TEXT_ALIGN] = align
            }
        }
        
        dict.merge(ViewCSSShadowConfig.toCSS(object: object, base: "text"), uniquingKeysWith: { (current, _) in current })
        
        return dict
    }
    
    func setAlign(dict: Dictionary<String, Any>) {
        self.align = self.valueFromDict(
            dict,
            attribute: type(of: self).TEXT_ALIGN,
            types: [.custom],
            match: nil)
        { (string: String) -> (Any?) in
            if string == "center" { return NSTextAlignment.center }
            else if string == "left" { return NSTextAlignment.left }
            else if string == "right" { return NSTextAlignment.right }
            else if string == "justify" { return NSTextAlignment.justified }
            return nil
        } as? NSTextAlignment
    }
}
