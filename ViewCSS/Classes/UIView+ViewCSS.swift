//
//  UIView+ViewCSS.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/29/17.
//

import Foundation

protocol ViewCSSTextProtocol {
    func setTextColor(_ color: UIColor)
    func setFont(_ font: UIFont)
    func setTextAlignment( _ alignment: NSTextAlignment)
}

extension UILabel: ViewCSSTextProtocol {
    func setTextColor(_ color: UIColor) { self.textColor = color }
    func setFont(_ font: UIFont) { self.font = font }
    func setTextAlignment( _ alignment: NSTextAlignment) { self.textAlignment = alignment }
}

extension UITextField: ViewCSSTextProtocol {
    func setTextColor(_ color: UIColor) { self.textColor = color }
    func setFont(_ font: UIFont) { self.font = font }
    func setTextAlignment( _ alignment: NSTextAlignment) { self.textAlignment = alignment }
}

extension UITextView: ViewCSSTextProtocol {
    func setTextColor(_ color: UIColor) { self.textColor = color }
    func setFont(_ font: UIFont) { self.font = font }
    func setTextAlignment( _ alignment: NSTextAlignment) { self.textAlignment = alignment }
}

public extension UIView {

    func css(style: String?) { self.css(style: style, class: nil) }
    func css(class klass: String?) { self.css(style: nil, class: klass) }
    func css(class klass: String?, style: String?) { self.css(style: style, class: klass) }
    
    func css(style: String?, class klass: String?) {
        
        // Set the style for this object
        let config = ViewCSSManager.shared.getConfig(object: self, style: style, class: klass)
        
        // BACKGROUND COLOR
        // If it is a UIView, check for main color first, else just background color
        if String(describing: type(of: self)) == "UIView" {
            if let color = config.color ?? config.backgroundColor {
                self.backgroundColor = color
            }
        }
        else {
            if let color = config.backgroundColor {
                self.backgroundColor = color
            }
        }
        
        // CORNER RADIUS
        if config.borderRadius != nil {
            self.layer.cornerRadius = config.borderRadius!
            self.layer.masksToBounds = true
        }
        
        // Check if it responds to text protocol
        if let textProtocol = self as? ViewCSSTextProtocol {
            let defaultFontSize: CGFloat = 15.0
            
            // Set the color
            if config.color != nil {
                textProtocol.setTextColor(config.color!)
            }
            
            // Set the size and the weight
            if #available(iOS 8.2, *) {
                if config.fontSize != nil || config.fontWeight != nil {
                    let scaledFontSize = round(15.0 * (config.fontSize ?? 1.0))
                    if config.fontWeight != nil {
                        textProtocol.setFont(UIFont.systemFont(ofSize: scaledFontSize, weight: config.fontWeight!))
                    }
                    else {
                        textProtocol.setFont(UIFont.systemFont(ofSize: scaledFontSize))
                    }
                }
            }
            else {
                if config.fontSize != nil {
                    let scaledFontSize = round(defaultFontSize * config.fontSize!)
                    textProtocol.setFont(UIFont.systemFont(ofSize: scaledFontSize))
                }
            }

            // Set the alignment
            if let textAlign = config.textAlign {
                textProtocol.setTextAlignment(textAlign)
            }
        }
    }
    
}
