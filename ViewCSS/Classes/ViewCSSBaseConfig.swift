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

let COLOR = "color"
let BACKGROUND_COLOR = "background-color"
let BORDER_RADIUS = "border-radius"
let BORDER_WIDTH = "border-width"
let BORDER_COLOR = "border-color"
let FONT_SIZE = "font-size"
let FONT_WEIGHT = "font-weight"
let FONT_SIZE_SCALE = "font-size-scale"
let FONT_SIZE_SCALE_MIN = "font-size-scale-min"
let FONT_SIZE_SCALE_MAX = "font-size-scale-max"
let OPACITY = "opacity"
let SHADOW = "shadow"
let SHADOW_OPACITY = "shadow-opacity"
let TEXT_ALIGN = "text-align"
let TEXT_DECORATION_LINE = "text-decoration-line"
let TEXT_DECORATION_COLOR = "text-decoration-color"
let TEXT_DECORATION_STYLE = "text-decoration-style"
let TEXT_OVERFLOW = "text-overflow"
let TEXT_TRANSFORM = "text-transform"
let TINT_COLOR = "tint-color"

public class ViewCSSBaseConfig {
    
    enum PropertyType {
        case color
        case length
        case number
        case percentage
        case custom
    }
    
    @discardableResult
    func valueFromCSS(_ css: Dictionary<String, Any?>,
                      attribute: String,
                      types:[PropertyType],
                      match: ((Any, PropertyType)->())?,
                      custom: ((String) -> (Any?))?=nil) -> Any? {
        
        return type(of: self).valueFromCSS(
            css, attribute: attribute, types: types, match: match, custom: custom)
    }
    
    @discardableResult
    static func valueFromCSS(_ css: Dictionary<String, Any?>,
                             attribute: String,
                             types:[PropertyType],
                             match: ((Any, PropertyType)->())?,
                             custom: ((String) -> (Any?))?=nil) -> Any? {
        
        if let string = css[attribute] as? String {
            let value = self.valueFromString(
                string, types: types, match: match, custom: custom)
            
            if value == nil {
                self.printWarning(attribute: attribute, value: string)
            }
            
            return value
        }
        
        return nil
    }
   
    @discardableResult
    func valueFromString(_ string: String?,
                         types:[PropertyType],
                         match: ((Any, PropertyType)->())?,
                         custom: ((String) -> (Any?))?=nil) -> Any? {
        
        return type(of: self).valueFromString(
            string, types: types, match: match, custom: custom)
    }
    
    @discardableResult
    static func valueFromString(_ string: String?,
                                types:[PropertyType],
                                match: ((Any, PropertyType)->())?,
                                custom: ((String) -> (Any?))?=nil) -> Any? {

        if let variabled = self.checkVariables(string: string) {
            let trimmedString = variabled.trimmingCharacters(in: .whitespaces)
            for type in types {
                var value: Any? = nil
                
                if type == .color {
                    value = UIColor(css: trimmedString)
                }
                else if type == .length {
                    value = trimmedString.lengthToFloat
                }
                else if type == .number {
                    value = trimmedString.numberToFloat
                }
                else if type == .percentage {
                    value = trimmedString.percentageToFloat
                }
                else if type == .custom && custom != nil {
                    value = custom!(trimmedString)
                }
                
                if value != nil {
                    if match != nil {
                        match!(value!, type)
                    }
                    return value
                }
            }
        }
  
        return nil
    }
    
    func printWarning(attribute: String, value: String) {
        type(of: self).printWarning(attribute: attribute, value: value)
    }
    
    static func printWarning(attribute: String, value: String) {
        print("ViewCSSManager WARN: Invalid CSS value '" + value + "' for attribute '" + attribute + "'")
    }
    
    static func checkVariables(string: String?) -> String? {
        return ViewCSSManager.shared.checkForVariable(string: string)
    }

}
