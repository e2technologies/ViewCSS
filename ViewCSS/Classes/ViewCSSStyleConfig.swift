//
//  ViewCSSStyleConfig.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/29/17.
//

import Foundation

class ViewCSSStyleConfig {
    var backgroundColor: UIColor?
    var color: UIColor?
    var fontSize: CGFloat?
    var fontWeight: UIFont.Weight?
    var textAlign: NSTextAlignment?
    
    func cssBackgroundColor(string: String?) {
        if string != nil {
            self.backgroundColor = UIColor(css: string!)
        }
    }
    
    func cssColor(string: String?) {
        if string != nil {
            self.color = UIColor(css: string!)
        }
    }
    
    func cssFontSize(string: String?) {
        if string != nil {
            self.fontSize = string!.percentageToFloat
        }
    }
    
    func cssFontWeightValue(string: String?) {
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
    
    func cssTextAlign(string: String?) {
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
}

