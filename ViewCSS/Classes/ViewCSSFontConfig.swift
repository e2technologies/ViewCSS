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

public class ViewCSSFontConfig: ViewCSSBaseConfig {
    
    static let DEFAULT_FONT_SIZE: CGFloat = 15
    static let AUTO_SCALE: CGFloat = -1.0 // Use the value of "-1" to represent auto scale
    
    static let FONT_SIZE = "font-size"
    static let FONT_WEIGHT = "font-weight"
    static let FONT_SIZE_SCALE = "font-size-scale"
    
    public private(set) var size: CGFloat?
    public private(set) var sizeScale: CGFloat?
    public private(set) var weight: UIFont.Weight?
    public var scaledSize: CGFloat? {
        if self.size != nil {
            var scale: CGFloat? = nil
            if self.sizeScale == type(of: self).AUTO_SCALE {
                scale = ViewCSSAutoScaleCache.shared.scale
            }
            else if self.sizeScale != nil {
                scale = self.sizeScale
            }
            
            if scale != nil {
                return (scale! * self.size!).rounded()
            }
            
            return self.size
        }
        
        return nil
    }
    
    static func fromCSS(dict: Dictionary<String, Any>) -> ViewCSSFontConfig {
        let config = ViewCSSFontConfig()
        
        config.cssSize(string: self.checkVariables(string: dict[FONT_SIZE] as? String))
        config.cssSizeScale(string: self.checkVariables(string: dict[FONT_SIZE_SCALE] as? String))
        config.cssWeight(string: self.checkVariables(string: dict[FONT_WEIGHT] as? String))
        
        return config
    }
    
    static func toCSS(object: Any) -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if let textProtocol = object as? ViewCSSTextProtocol {
            if let font = textProtocol.getCSSFont() {
                dict[FONT_SIZE] = font.pointSize.toPX
                // TODO: Get font weight
            }
        }
        
        return dict
    }
    
    public func getFont() -> UIFont? {
        // Set the size and the weight
        if #available(iOS 8.2, *) {
            if self.scaledSize != nil {
                if self.weight != nil {
                    return UIFont.systemFont(ofSize: self.scaledSize!, weight: self.weight!)
                }
                else {
                    return UIFont.systemFont(ofSize: self.scaledSize!)
                }
            }
        }
        else {
            if self.scaledSize != nil {
                return UIFont.systemFont(ofSize: self.scaledSize!)
            }
        }
        
        return nil
    }
    
    private func cssSize(string: String?) {
        if string != nil {
            let trimmedString = string!.trimmingCharacters(in: .whitespaces)
            
            if let percentage = trimmedString.percentageToFloat {
                self.size = type(of: self).DEFAULT_FONT_SIZE * percentage
            }
            else if let length = trimmedString.lengthToFloat {
                self.size = length
            }
            else {
                var offset: CGFloat? = nil
                switch trimmedString {
                case "xx-small":
                    offset = -6
                case "x-small":
                    offset = -4
                case "small":
                    offset = -2
                case "medium":
                    offset = 0
                case "large":
                    offset = 2
                case "x-large":
                    offset = 4
                case "xx-large":
                    offset = 6
                default:
                    offset = nil
                }
                
                if offset != nil {
                    self.size = type(of: self).DEFAULT_FONT_SIZE + offset!
                }
            }
            
            if self.size == nil {
                self.printWarning(attribute: type(of: self).FONT_SIZE, value: string!)
            }
        }
    }
    
    private func cssSizeScale(string: String?) {
        if string != nil {
            let trimmedString = string!.trimmingCharacters(in: .whitespaces)
            
            if trimmedString == "auto" {
                self.sizeScale = type(of: self).AUTO_SCALE
            }
            else if let number = trimmedString.numberToFloat {
                self.sizeScale = number
            }
            
            if self.sizeScale == nil {
                self.printWarning(attribute: type(of: self).FONT_SIZE_SCALE, value: string!)
            }
        }
    }
    
    private func cssWeight(string: String?) {
        if string != nil {
            if #available(iOS 8.2, *) {
                switch string! {
                case "normal":
                    self.weight = UIFont.Weight.regular
                case "bold":
                    self.weight = UIFont.Weight.bold
                case "bolder":
                    self.weight = UIFont.Weight.black
                case "lighter":
                    self.weight = UIFont.Weight.thin
                case "100":
                    self.weight = UIFont.Weight.ultraLight
                case "200":
                    self.weight = UIFont.Weight.thin
                case "300":
                    self.weight = UIFont.Weight.light
                case "400":
                    self.weight = UIFont.Weight.regular
                case "500":
                    self.weight = UIFont.Weight.medium
                case "600":
                    self.weight = UIFont.Weight.semibold
                case "700":
                    self.weight = UIFont.Weight.bold
                case "800":
                    self.weight = UIFont.Weight.heavy
                case "900":
                    self.weight = UIFont.Weight.black
                default:
                    self.weight = nil
                }
            }
            
            if self.weight == nil {
                self.printWarning(attribute: type(of: self).FONT_WEIGHT, value: string!)
            }
        }
    }
}
