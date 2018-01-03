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

public class ViewCSSBaseConfig {
    
    enum PropertyType {
        case color
        case length
        case number
        case percentage
    }
    
    static func valueFromDict(_ dict: Dictionary<String, Any?>, attribute: String, types:[PropertyType]) -> Any? {
        let string = dict[attribute] as? String
        let value = self.valueFromString(string, types: types)
        
        if value == nil {
            // TODO: Report Error
        }
        
        return value
    }
    
    static func valueFromString(_ string: String?, types:[PropertyType]) -> Any? {
        if string == nil { return nil }
        
        for type in types {
            let trimmedString = string!.trimmingCharacters(in: .whitespaces)
            if type == .color {
                return UIColor(css: trimmedString)
            }
            else if type == .length {
                return trimmedString.lengthToFloat
            }
            else if type == .number {
                return trimmedString.numberToFloat
            }
            else if type == .percentage {
                return trimmedString.percentageToFloat
            }
        }
        
        return nil
    }
    
    func printWarning(attribute: String, value: String) {
        print("ViewCSSManager WARN: Invalid CSS value '" + value + "' for attribute '" + attribute + "'")
    }
    
    static func checkVariables(string: String?) -> String? {
        return ViewCSSManager.shared.checkForVariable(string: string)
    }
}
