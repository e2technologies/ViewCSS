//
//  ViewCSSStyleConfig.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/29/17.
//

import Foundation

class ViewCSSStyleConfig {
    // Supported Tags
    static let BACKGROUND_COLOR = "background-color"
    static let COLOR = "color"
    static let FONT_SIZE = "font-size"
    static let FONT_WEIGHT = "font-weight"
    static let TEXT_ALIGN = "text-align"
    static let BORDER_RADIUS = "border-radius"
    
    var backgroundColor: UIColor?
    var color: UIColor?
    var fontSize: CGFloat?
    var fontWeight: UIFont.Weight?
    var textAlign: NSTextAlignment?
    var borderRadius: CGFloat?
    
    static func fromCSS(dict: Dictionary<String, Any>, root: Dictionary<String, Any>?) -> ViewCSSStyleConfig {
        let config = ViewCSSStyleConfig()
        
        config.cssBackgroundColor(string: self.checkRootVariables(string: dict[BACKGROUND_COLOR] as? String, root: root))
        config.cssColor(string: self.checkRootVariables(string: dict[COLOR] as? String, root: root))
        config.cssFontSize(string: self.checkRootVariables(string: dict[FONT_SIZE] as? String, root: root))
        config.cssFontWeightValue(string: self.checkRootVariables(string: dict[FONT_WEIGHT] as? String, root: root))
        config.cssTextAlign(string: self.checkRootVariables(string: dict[TEXT_ALIGN] as? String, root: root))
        config.cssBorderRadius(string: self.checkRootVariables(string: dict[BORDER_RADIUS] as? String, root: root))
        
        return config
    }
    
    private static func checkRootVariables(string: String?, root: Dictionary<String, Any>?) -> String? {
        if root == nil { return string }
        if string == nil { return nil }
        
        var newString = string!.trimmingCharacters(in: .whitespaces)
        if newString.hasPrefix("var(") {
            newString = String(newString.dropFirst(4))
            newString = String(newString.dropLast(1))
            return (root![newString] as? String) ?? string
        }
        return string
    }
    
    private func cssBackgroundColor(string: String?) {
        if string != nil {
            self.backgroundColor = UIColor(css: string!)
        }
    }
    
    private func cssColor(string: String?) {
        if string != nil {
            self.color = UIColor(css: string!)
        }
    }
    
    private func cssFontSize(string: String?) {
        if string != nil {
            self.fontSize = string!.percentageToFloat
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
        }
    }
}

