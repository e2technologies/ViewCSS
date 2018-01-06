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
    static let TEXT_TRANSFORM = "text-transform"
    static let TEXT_DECORATION_LINE = "text-decoration-line"
    static let TEXT_DECORATION_COLOR = "text-decoration-color"
    static let TEXT_DECORATION_STYLE = "text-decoration-style"
    
    public enum Transform {
        case uppercase
        case lowercase
        case capitalize
    }
    
    public enum DecorationLine {
        case underline
        case overline
        case line_through
    }
    
    public private(set) var align: NSTextAlignment?
    public private(set) var shadow: ViewCSSShadowConfig?
    public private(set) var transform: Transform?
    public private(set) var decorationLine: DecorationLine?
    public private(set) var decorationColor: UIColor?
    public private(set) var decorationStyle: NSUnderlineStyle?
    
    static func fromCSS(dict: Dictionary<String, Any>) -> ViewCSSTextConfig {
        let config = ViewCSSTextConfig()
        
        config.shadow = ViewCSSShadowConfig.fromCSS(dict: dict, base: "text")
        config.setAlign(dict: dict)
        config.setTransform(dict: dict)
        config.setDecorationLine(dict: dict)
        config.setDecorationStyle(dict: dict)
        config.setDecorationColor(dict: dict)
        
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
    
    func setTransform(dict: Dictionary<String, Any>) {
        self.transform = self.valueFromDict(
            dict,
            attribute: type(of: self).TEXT_TRANSFORM,
            types: [.custom],
            match: nil)
        { (string: String) -> (Any?) in
            if string == "uppercase" { return Transform.uppercase }
            else if string == "lowercase" { return Transform.lowercase }
            else if string == "capitalize" { return Transform.capitalize }
            return nil
            } as? Transform
    }
    
    func setDecorationLine(dict: Dictionary<String, Any>) {
        self.decorationLine = self.valueFromDict(
            dict,
            attribute: type(of: self).TEXT_DECORATION_LINE,
            types: [.custom],
            match: nil)
        { (string: String) -> (Any?) in
            if string == "overline" { return DecorationLine.overline }
            else if string == "underline" { return DecorationLine.underline }
            else if string == "line-through" { return DecorationLine.line_through }
            return nil
            } as? DecorationLine
    }
    
    func setDecorationColor(dict: Dictionary<String, Any>) {
        self.decorationColor = self.valueFromDict(
            dict,
            attribute: type(of: self).TEXT_DECORATION_COLOR,
            types: [.color],
            match: nil) as? UIColor
    }
    
    func setDecorationStyle(dict: Dictionary<String, Any>) {
        self.decorationStyle = self.valueFromDict(
            dict,
            attribute: type(of: self).TEXT_DECORATION_STYLE,
            types: [.custom],
            match: nil)
        { (string: String) -> (Any?) in
            if string == "solid" { return NSUnderlineStyle.styleSingle }
            else if string == "double" { return NSUnderlineStyle.styleDouble }
            else if string == "dotted" { return NSUnderlineStyle.patternDot }
            else if string == "dashed" { return NSUnderlineStyle.patternDash }
            return nil
            } as? NSUnderlineStyle
    }
}
