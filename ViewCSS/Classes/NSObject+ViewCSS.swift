import Foundation

public extension NSObject {

    // ================================================================
    // CSS Methods
    // ================================================================

    func css(object: Any?=nil, class klass: String?=nil, style: String?=nil, custom: ((ViewCSSConfig) -> Void)?=nil) {
        let className = ViewCSSManager.shared.getClassName(object: self)
        if let target = (object ?? self) as? UIView {
            target.css(className: className, class: klass, style: style, custom: custom)
            
            // Check if there is a defined custom CSS method
            if let customizeProtocol = self as? ViewCSSCustomizableProtocol {
                let config = target.cssConfig(class: klass, style: style)
                customizeProtocol.cssCustomize(object: object, class: klass, style: style, config: config)
            }
        }
    }
    
    // ================================================================
    // CSS Config Methods
    // ================================================================
    
    func cssConfig(class klass: String?=nil, style: String?=nil) -> ViewCSSConfig {
        let cssManager = ViewCSSManager.shared
        let className = cssManager.getClassName(object: self)
        return cssManager.getConfig(className: className, class: klass, style: style)
    }
    
    // ================================================================
    // CSS Class Config Methods
    // ================================================================
    
    class func cssConfig(class klass: String?=nil, style: String?=nil) -> ViewCSSConfig {
        let cssManager = ViewCSSManager.shared
        let className = cssManager.getClassName(class: self)
        return cssManager.getConfig(className: className, class: klass, style: style)
    }
    
    // ================================================================
    // CSS Scale Properties
    // ================================================================
    
    var cssScale: CGFloat {
        return ViewCSSAutoScaleCache.shared.scale
    }
    
    class var cssScale: CGFloat {
        return ViewCSSAutoScaleCache.shared.scale
    }
}
