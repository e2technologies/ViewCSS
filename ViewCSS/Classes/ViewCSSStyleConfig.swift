//
//  ViewCSSStyleConfig.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/29/17.
//

import Foundation

public class ViewCSSStyleConfig {
    
    static let DEFAULT_FONT_SIZE: CGFloat = 15
    
    // Supported Tags
    static let BACKGROUND_COLOR = "background-color"
    static let TINT_COLOR = "tint-color"
    static let COLOR = "color"
    static let FONT_SIZE = "font-size"
    static let FONT_WEIGHT = "font-weight"
    static let TEXT_ALIGN = "text-align"
    static let BORDER_RADIUS = "border-radius"
    static let OPACITY = "opacity"
    
    var backgroundColor: UIColor?
    var tintColor: UIColor?
    var color: UIColor?
    var fontSize: CGFloat?
    var fontWeight: UIFont.Weight?
    var textAlign: NSTextAlignment?
    var borderRadius: CGFloat?
    var opacity: CGFloat?
    
    static func fromCSS(dict: Dictionary<String, Any>) -> ViewCSSStyleConfig {
        let config = ViewCSSStyleConfig()
        
        config.cssBackgroundColor(string: self.checkVariables(string: dict[BACKGROUND_COLOR] as? String))
        config.cssTintColor(string: self.checkVariables(string: dict[TINT_COLOR] as? String))
        config.cssColor(string: self.checkVariables(string: dict[COLOR] as? String))
        config.cssFontSize(string: self.checkVariables(string: dict[FONT_SIZE] as? String))
        config.cssFontWeightValue(string: self.checkVariables(string: dict[FONT_WEIGHT] as? String))
        config.cssTextAlign(string: self.checkVariables(string: dict[TEXT_ALIGN] as? String))
        config.cssBorderRadius(string: self.checkVariables(string: dict[BORDER_RADIUS] as? String))
        config.cssOpacity(string: self.checkVariables(string: dict[OPACITY] as? String))
        
        return config
    }
    
    private func printWarning(attribute: String, value: String) {
        print("ViewCSSManager WARN: Invalid CSS value '" + value + "' for attribute '" + attribute + "'")
    }
    
    private static func checkVariables(string: String?) -> String? {
        return ViewCSSManager.shared.checkForVariable(string: string)
    }
    
    private func cssBackgroundColor(string: String?) {
        if string != nil {
            self.backgroundColor = UIColor(css: string!)
            if self.backgroundColor == nil {
                self.printWarning(attribute: type(of: self).BACKGROUND_COLOR, value: string!)
            }
        }
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
    
    private func cssFontSize(string: String?) {
        if string != nil {
            let trimmedString = string!.trimmingCharacters(in: .whitespaces)
            
            if trimmedString.hasSuffix("%") {
                if let percentage = trimmedString.percentageToFloat {
                    self.fontSize = type(of: self).DEFAULT_FONT_SIZE * percentage
                }
            }
            else if trimmedString.hasSuffix("px") {
                let tempString = String(trimmedString.dropLast(2))
                if let tempInt = UInt(tempString) {
                    self.fontSize = CGFloat(tempInt)
                }
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
                    self.fontSize = type(of: self).DEFAULT_FONT_SIZE + offset!
                }
            }
            
            if self.fontSize == nil {
                self.printWarning(attribute: type(of: self).FONT_SIZE, value: string!)
            }
        }
    }
    
    private func cssFontWeightValue(string: String?) {
        if string != nil {
            if #available(iOS 8.2, *) {
                switch string! {
                case "normal":
                    self.fontWeight = UIFont.Weight.regular
                case "bold":
                    self.fontWeight = UIFont.Weight.bold
                case "bolder":
                    self.fontWeight = UIFont.Weight.black
                case "lighter":
                    self.fontWeight = UIFont.Weight.thin
                case "100":
                    self.fontWeight = UIFont.Weight.ultraLight
                case "200":
                    self.fontWeight = UIFont.Weight.thin
                case "300":
                    self.fontWeight = UIFont.Weight.light
                case "400":
                    self.fontWeight = UIFont.Weight.regular
                case "500":
                    self.fontWeight = UIFont.Weight.medium
                case "600":
                    self.fontWeight = UIFont.Weight.semibold
                case "700":
                    self.fontWeight = UIFont.Weight.bold
                case "800":
                    self.fontWeight = UIFont.Weight.heavy
                case "900":
                    self.fontWeight = UIFont.Weight.black
                default:
                    self.fontWeight = nil
                }
            } else {
                self.printWarning(attribute: type(of: self).FONT_WEIGHT, value: string!)
                self.fontWeight = nil
            }
        }
    }
    
    private func cssTextAlign(string: String?) {
        if string != nil {
            switch string! {
            case "center":
                self.textAlign = NSTextAlignment.center
            case "left":
                self.textAlign = NSTextAlignment.left
            case "right":
                self.textAlign = NSTextAlignment.right
            case "justify":
                self.textAlign = NSTextAlignment.justified
            default:
                self.printWarning(attribute: type(of: self).TEXT_ALIGN, value: string!)
                self.textAlign = nil
            }
        }
    }
    
    private func cssBorderRadius(string: String?) {
        if string != nil && string!.hasSuffix("px") {
            let tempString = string!.dropLast(2)
            if let tempInt = UInt(tempString) {
                self.borderRadius = CGFloat(tempInt)
            }
            else {
                self.printWarning(attribute: type(of: self).BORDER_RADIUS, value: string!)
            }
        }
    }
    
    private func cssOpacity(string: String?) {
        if string != nil {
            if let tempNumber = NumberFormatter().number(from: string!) {
                self.opacity = CGFloat(truncating: tempNumber)
            }
            else {
                self.printWarning(attribute: type(of: self).OPACITY, value: string!)
            }
        }
    }
}

