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
    
    public private(set) var size: CGFloat?
    public private(set) var sizeScale: CGFloat?
    public private(set) var sizeScaleMin: CGFloat?
    public private(set) var sizeScaleMax: CGFloat?
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
                var newSize = scale! * self.size!
                
                // Check min
                if self.sizeScaleMin != nil && newSize < self.sizeScaleMin! {
                    newSize = self.sizeScaleMin!
                }
                
                // Check min
                if self.sizeScaleMax != nil && newSize > self.sizeScaleMax! {
                    newSize = self.sizeScaleMax!
                }
                
                return newSize.rounded()
            }
            
            return self.size
        }
        
        return nil
    }
    
    func getFontRelatedValue(
        css: Dictionary<String, Any>,
        attribute: String,
        custom: ((String) -> (Any?))?=nil) -> CGFloat? {
        
        var returnValue: CGFloat? = nil
        
        self.valueFromCSS(
            css,
            attribute: attribute,
            types: [.percentage, .length, .number, .custom],
            match:
            { (value: Any, type: ViewCSSBaseConfig.PropertyType) in
                if type == .percentage, let percentage = value as? CGFloat {
                    returnValue = ViewCSSFontConfig.DEFAULT_FONT_SIZE * percentage
                }
                else if type == .length, let length = value as? CGFloat {
                    returnValue = length
                }
                else if type == .number, let number = value as? CGFloat {
                    returnValue = ViewCSSFontConfig.DEFAULT_FONT_SIZE * number
                }
                else if type == .custom, let offset = value as? CGFloat {
                    returnValue = ViewCSSFontConfig.DEFAULT_FONT_SIZE + offset
                }
        }, custom: custom)
        
        return returnValue
    }
    
    init(css: Dictionary<String, Any>) {
        super.init()
        
        // Weight
        self.weight = self.valueFromCSS(
            css, attribute: FONT_WEIGHT, types: [.custom], match: nil)
        { (string: String) in
            if #available(iOS 8.2, *) {
                if string == "normal" { return UIFont.Weight.regular }
                else if string == "bold" { return UIFont.Weight.bold }
                else if string == "bolder" { return UIFont.Weight.black }
                else if string == "lighter" { return UIFont.Weight.thin }
                else if string == "100" { return UIFont.Weight.ultraLight }
                else if string == "200" { return UIFont.Weight.thin }
                else if string == "300" { return UIFont.Weight.light }
                else if string == "400" { return UIFont.Weight.regular }
                else if string == "500" { return UIFont.Weight.medium }
                else if string == "600" { return UIFont.Weight.semibold }
                else if string == "700" { return UIFont.Weight.bold }
                else if string == "800" { return UIFont.Weight.heavy }
                else if string == "900" { return UIFont.Weight.black }
            }
            return nil
            } as? UIFont.Weight
        
        // Size Scale Settings
        self.sizeScale = self.valueFromCSS(
            css, attribute: FONT_SIZE_SCALE, types: [.custom, .number], match: nil)
        { (string: String) in
            if string == "auto" { return ViewCSSFontConfig.AUTO_SCALE }
            else { return nil }
            } as? CGFloat
        
        self.size = getFontRelatedValue(css: css, attribute: FONT_SIZE)
        { (string: String) in
            if string == "xx-small" { return CGFloat(-6) }
            else if string == "x-small" { return CGFloat(-4) }
            else if string == "small" { return CGFloat(-2) }
            else if string == "medium" { return CGFloat(0) }
            else if string == "large" { return CGFloat(2) }
            else if string == "x-large" { return CGFloat(4) }
            else if string == "xx-large" { return CGFloat(6) }
            else { return nil }
        }
        
        self.sizeScaleMin = getFontRelatedValue(css: css, attribute: FONT_SIZE_SCALE_MIN)
        self.sizeScaleMax = getFontRelatedValue(css: css, attribute: FONT_SIZE_SCALE_MAX)
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

}
