//
//  UIView+ViewCSS.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/29/17.
//

import Foundation

public extension UIView {

    func css(style: String?) {
        self.css(style: style, class: nil)
    }
    
    func css(class klass: String?) {
        self.css(style: nil, class: klass)
    }
    
    func css(class klass: String?, style: String?) {
        self.css(style: style, class: klass)
    }
    
    func css(style: String?, class klass: String?) {
        
        // Set the style for this object
        let config = ViewCSSManager.shared.getConfig(object: self, style: style, class: klass)
        
        // Set the static atttributes
        if let backgroundColor = config.backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        // UILabel methods
        // TODO: Move this to another extension once extension declarations can be overriden and
        // call the super
        if let selfLabel = self as? UILabel {
            let defaultFontSize: CGFloat = 15.0
            
            // Set the color
            if config.color != nil {
                selfLabel.textColor = config.color
            }
            
            // Set the size and the weight
            if #available(iOS 8.2, *) {
                if config.fontSize != nil || config.fontWeight != nil {
                    let scaledFontSize = round(15.0 * (config.fontSize ?? 1.0))
                    if config.fontWeight != nil {
                        selfLabel.font = UIFont.systemFont(ofSize: scaledFontSize, weight: config.fontWeight!)
                    }
                    else {
                        selfLabel.font = UIFont.systemFont(ofSize: scaledFontSize)
                    }
                }
            }
            else {
                if config.fontSize != nil {
                    let scaledFontSize = round(defaultFontSize * config.fontSize!)
                    selfLabel.font = UIFont.systemFont(ofSize: scaledFontSize)
                }
            }

            // Set the alignment
            if let textAlign = config.textAlign {
                selfLabel.textAlignment = textAlign
            }
        }
    }
    
}
