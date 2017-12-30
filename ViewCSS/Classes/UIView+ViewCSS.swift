//
//  UIView+ViewCSS.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/29/17.
//

import Foundation

private var StyleObjectHandle: UInt8 = 0
public extension UIView {
    
    private var style: String? {
        get {
            return objc_getAssociatedObject(self, &StyleObjectHandle) as? String
        }
        set {
            objc_setAssociatedObject(self, &StyleObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func style(_ style: String) {
        self.style = style
        
        // Set the style for this object
        let config = ViewCSSManager.shared.getConfig(object: self, style: style)
        
        // Set the static atttributes
        if let backgroundColor = config.backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        // UILabel methods
        // TODO: Move this to another extension once extension declarations can be overriden and
        // call the super
        if let selfLabel = self as? UILabel {
            if let color = config.color {
                selfLabel.textColor = color
            }
            if let fontSize = config.fontSize {
                let scaledFontSize = round(15.0 * fontSize)
                if #available(iOS 8.2, *) {
                    if let fontWeight = config.fontWeight {
                        selfLabel.font = UIFont.systemFont(ofSize: scaledFontSize, weight: fontWeight)
                    }
                    else {
                        selfLabel.font = UIFont.systemFont(ofSize: scaledFontSize)
                    }
                }
                else {
                    selfLabel.font = UIFont.systemFont(ofSize: scaledFontSize)
                }
            }
            if let textAlign = config.textAlign {
                selfLabel.textAlignment = textAlign
            }
        }
    }
    
}
