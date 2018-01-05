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

public class ViewCSSBackgroundConfig: ViewCSSBaseConfig {
    
    static let BACKGROUND_COLOR = "background-color"
    
    public private(set) var color: UIColor?
    
    static func fromCSS(dict: Dictionary<String, Any>) -> ViewCSSBackgroundConfig {
        let config = ViewCSSBackgroundConfig()
        
        config.setColor(dict: dict)

        return config
    }
    
    static func toCSS(object: Any) -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if let viewProtocol = object as? ViewCSSProtocol {
            if let backgroundColor = viewProtocol.getCSSBackgroundColor() {
                dict[BACKGROUND_COLOR] = backgroundColor.toCSS
            }
        }
        
        return dict
    }
    
    func setColor(dict: Dictionary<String, Any>) {
        self.color = self.valueFromDict(
            dict,
            attribute: type(of: self).BACKGROUND_COLOR,
            types: [.color],
            match: nil) as? UIColor
    }
}