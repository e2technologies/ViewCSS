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
    func printWarning(attribute: String, value: String) {
        print("ViewCSSManager WARN: Invalid CSS value '" + value + "' for attribute '" + attribute + "'")
    }
    
    static func checkVariables(string: String?) -> String? {
        return ViewCSSManager.shared.checkForVariable(string: string)
    }
}

public class ViewCSSBackgroundConfig: ViewCSSBaseConfig {
    
    static let BACKGROUND_COLOR = "background-color"
    
    public private(set) var color: UIColor?
    
    static func fromCSS(dict: Dictionary<String, Any>) -> ViewCSSBackgroundConfig {
        let config = ViewCSSBackgroundConfig()
        
        config.cssColor(string: self.checkVariables(string: dict[BACKGROUND_COLOR] as? String))
        
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
    
    private func cssColor(string: String?) {
        if string != nil {
            self.color = UIColor(css: string!)
            
            if self.color == nil {
                self.printWarning(attribute: type(of: self).BACKGROUND_COLOR, value: string!)
            }
        }
    }
}

public class ViewCSSTextConfig: ViewCSSBaseConfig {
    
    static let TEXT_ALIGN = "text-align"
    
    public private(set) var align: NSTextAlignment?
    
    static func fromCSS(dict: Dictionary<String, Any>) -> ViewCSSTextConfig {
        let config = ViewCSSTextConfig()
        
        config.cssAlign(string: self.checkVariables(string: dict[TEXT_ALIGN] as? String))
        
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
        
        return dict
    }
    
    private func cssAlign(string: String?) {
        if string != nil {
            switch string! {
            case "center":
                self.align = NSTextAlignment.center
            case "left":
                self.align = NSTextAlignment.left
            case "right":
                self.align = NSTextAlignment.right
            case "justify":
                self.align = NSTextAlignment.justified
            default:
                self.align = nil
            }
            
            if self.align == nil {
                self.printWarning(attribute: type(of: self).TEXT_ALIGN, value: string!)
            }
        }
    }
}

private class ViewCSSAutoScaleCache {
    public static var shared: ViewCSSAutoScaleCache = {
        return ViewCSSAutoScaleCache()
    }()
    
    var scale: CGFloat = 1.0
    
    @objc func updateScale() {
        switch UIApplication.shared.preferredContentSizeCategory {
        case .extraSmall:
            self.scale = 0.8
        case .small:
            self.scale = 0.9
        case .medium:
            self.scale = 1.0
        case .large:
            self.scale = 1.1
        case .extraLarge:
            self.scale = 1.2
        case .extraExtraLarge:
            self.scale = 1.3
        case .extraExtraExtraLarge:
            self.scale = 1.4
        case .accessibilityMedium:
            self.scale = 1.5
        case .accessibilityLarge:
            self.scale = 1.6
        case .accessibilityExtraLarge:
            self.scale = 1.7
        case .accessibilityExtraExtraLarge:
            self.scale = 1.8
        case .accessibilityExtraExtraExtraLarge:
            self.scale = 1.8
        default:
            self.scale = 1.0
        }
        
        // Clear the View Manager Cache since the scale was updated
        ViewCSSManager.shared.clearCache()
    }
    
    init() {
        self.updateScale()
        
        // Subscribe to update notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateScale),
                                               name: NSNotification.Name.UIContentSizeCategoryDidChange,
                                               object: nil)
    }
}

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
    
    func getFont() -> UIFont? {
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

public class ViewCSSBorderConfig: ViewCSSBaseConfig {
    
    static let BORDER_RADIUS = "border-radius"
    static let BORDER_WIDTH = "border-width"
    static let BORDER_COLOR = "border-color"
    
    public private(set) var radius: CGFloat?
    public private(set) var width: CGFloat?
    public private(set) var color: UIColor?
    
    static func fromCSS(dict: Dictionary<String, Any>) -> ViewCSSBorderConfig {
        let config = ViewCSSBorderConfig()
        
        config.cssRadius(string: self.checkVariables(string: dict[BORDER_RADIUS] as? String))
        config.cssColor(string: self.checkVariables(string: dict[BORDER_COLOR] as? String))
        config.cssWidth(string: self.checkVariables(string: dict[BORDER_WIDTH] as? String))
        
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
    
    private func cssRadius(string: String?) {
        if string != nil {
            if let radius = string!.lengthToFloat {
                self.radius = radius
            }
            
            if self.radius == nil {
                self.printWarning(attribute: type(of: self).BORDER_RADIUS, value: string!)
            }
        }
    }
    
    private func cssColor(string: String?) {
        if string != nil {
            self.color = UIColor(css: string!)
            
            if self.color == nil {
                self.printWarning(attribute: type(of: self).BORDER_COLOR, value: string!)
            }
        }
    }
    
    private func cssWidth(string: String?) {
        if string != nil {
            let trimmedString = string!.trimmingCharacters(in: .whitespaces)
            
            if let length = trimmedString.lengthToFloat {
                self.width = length
            }
            else {
                switch trimmedString {
                case "medium":
                    self.width = 2
                case "thin":
                    self.width = 1
                case "thick":
                    self.width = 3
                default:
                    self.width = nil
                }
            }
            
            if self.width == nil {
                self.printWarning(attribute: type(of: self).BORDER_WIDTH, value: string!)
            }
        }
    }
}

public class ViewCSSConfig: ViewCSSBaseConfig {
    
    // Supported Tags
    static let TINT_COLOR = "tint-color"
    static let COLOR = "color"
    static let OPACITY = "opacity"
    

    public private(set) var font: ViewCSSFontConfig?
    public private(set) var border: ViewCSSBorderConfig?
    public private(set) var text: ViewCSSTextConfig?
    public private(set) var background: ViewCSSBackgroundConfig?
    public private(set) var tintColor: UIColor?
    public private(set) var color: UIColor?
    public private(set) var opacity: CGFloat?
    
    static func fromCSS(dict: Dictionary<String, Any>) -> ViewCSSConfig {
        let config = ViewCSSConfig()
        
        config.border = ViewCSSBorderConfig.fromCSS(dict: dict)
        config.font = ViewCSSFontConfig.fromCSS(dict: dict)
        config.text = ViewCSSTextConfig.fromCSS(dict: dict)
        config.background = ViewCSSBackgroundConfig.fromCSS(dict: dict)
        config.cssTintColor(string: self.checkVariables(string: dict[TINT_COLOR] as? String))
        config.cssColor(string: self.checkVariables(string: dict[COLOR] as? String))
        config.cssOpacity(string: self.checkVariables(string: dict[OPACITY] as? String))
        
        return config
    }
    
    static func toCSS(object: Any) -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if let viewProtocol = object as? ViewCSSProtocol {
            if let tintColor = viewProtocol.getCSSTintColor() {
                let tintColorCSS = tintColor.toCSS
                // Ignore Apple default
                if tintColorCSS != "#007AFFFF" {
                    dict[TINT_COLOR] = tintColorCSS
                }
            }
            let opacity = viewProtocol.getCSSOpacity()
            if opacity < 1.0 {
                dict[OPACITY] = String(format:"%f", opacity)
            }
        }
        
        if let textProtocol = object as? ViewCSSTextProtocol {
            if let color = textProtocol.getCSSTextColor() {
                dict[COLOR] = color.toCSS
            }
        }
        
        dict.merge(ViewCSSBackgroundConfig.toCSS(object: object), uniquingKeysWith: { (current, _) in current })
        dict.merge(ViewCSSFontConfig.toCSS(object: object), uniquingKeysWith: { (current, _) in current })
        dict.merge(ViewCSSBorderConfig.toCSS(object: object), uniquingKeysWith: { (current, _) in current })
        dict.merge(ViewCSSTextConfig.toCSS(object: object), uniquingKeysWith: { (current, _) in current })
        
        return dict
    }
    
    private func cssTintColor(string: String?) {
        if string != nil {
            self.tintColor = UIColor(css: string!)
            
            if self.tintColor == nil {
                self.printWarning(attribute: type(of: self).TINT_COLOR, value: string!)
            }
        }
    }
    
    private func cssColor(string: String?) {
        if string != nil {
            self.color = UIColor(css: string!)
            
            if self.color == nil {
                self.printWarning(attribute: type(of: self).COLOR, value: string!)
            }
        }
    }
    
    private func cssOpacity(string: String?) {
        if string != nil {
            if let number = string!.numberToFloat {
                self.opacity = number
            }
            
            if self.opacity == nil {
                self.printWarning(attribute: type(of: self).OPACITY, value: string!)
            }
        }
    }
}

