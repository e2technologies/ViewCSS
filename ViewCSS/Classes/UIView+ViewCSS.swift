import Foundation

extension UIView: ViewCSSProtocol {
    func setCSSBackgroundColor(_ color: UIColor) { self.backgroundColor = color }
    func setCSSTintColor(_ color: UIColor) { self.tintColor = color }
    func setCSSBorderRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    func setCSSBorder(width: CGFloat, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    func setCSSOpacity(_ opacity: CGFloat) { self.alpha = opacity }
    
    func getCSSBackgroundColor() -> UIColor? { return self.backgroundColor }
    func getCSSTintColor() -> UIColor? { return self.tintColor }
    func getCSSBorderRadius() -> CGFloat { return self.layer.cornerRadius }
    func getCSSBorderWidth() -> CGFloat { return self.layer.borderWidth }
    func getCSSBorderColor() -> UIColor? { return self.layer.borderColor != nil ? UIColor(cgColor: self.layer.borderColor!) : nil }
    func getCSSOpacity() -> CGFloat { return self.alpha }
}

private var CSSKeyClassNameHandle: UInt8 = 0
private var CSSKeyClassHandle: UInt8 = 0
private var CSSKeyStyleHandle: UInt8 = 0

extension UIView {
    
    var cssClassName: String? {
        get {
            return objc_getAssociatedObject(self, &CSSKeyClassNameHandle) as? String
        }
        set {
            objc_setAssociatedObject(self, &CSSKeyClassNameHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var cssClass: String? {
        get {
            return objc_getAssociatedObject(self, &CSSKeyClassHandle) as? String
        }
        set {
            objc_setAssociatedObject(self, &CSSKeyClassHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var cssStyle: String? {
        get {
            return objc_getAssociatedObject(self, &CSSKeyStyleHandle) as? String
        }
        set {
            objc_setAssociatedObject(self, &CSSKeyStyleHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func css(className: String, class klass: String?, style: String?, custom: ((ViewCSSConfig) -> Void)?=nil) {
        let cssManager = ViewCSSManager.shared
        
        // Store the class name, class, and style for later reference
        self.cssClassName = className
        self.cssClass = klass
        self.cssStyle = style
        
        // Clear the missing flag (probably a better place to do this)
        cssManager.classMissing = false
        
        // Get the config
        let config = cssManager.getConfig(className: className, class: klass, style: style)
        
        // background-color
        if let color = config.background?.color {
            self.setCSSBackgroundColor(color)
        }
        
        // tint-color
        if let color = config.tintColor {
            self.setCSSTintColor(color)
        }
        
        // opacity
        if let opacity = config.opacity {
            self.setCSSOpacity(opacity)
        }
        
        // border-radius
        if let radius = config.border?.radius {
            self.setCSSBorderRadius(radius)
        }
        
        // border-width, border-color
        if let width = config.border?.width {
            if let color = config.border?.color {
                self.setCSSBorder(width: width, color: color)
            }
        }
        
        // Check if it responds to shadow protocol
        if let shadowProtocol = self as? ViewCSSShadowProtocol {
            
            // Get the correct shadow config
            var shadow: ViewCSSShadowConfig? = nil
            
            // text-shadow
            if config.text?.shadow != nil {
                shadow = config.text?.shadow
            }
            
            // If we have a valid shadow config, configure it
            if shadow != nil && shadow!.vShadow != nil && shadow!.hShadow != nil {
                shadowProtocol.setCSSShadow(offset: CGSize(width: shadow!.hShadow!, height: shadow!.vShadow!),
                                            radius: shadow!.radius,
                                            color: shadow!.color,
                                            opacity: (shadow!.opacity ?? 1.0))
            }
        }
        
        // Check if it responds to text protocol
        if let textProtocol = self as? ViewCSSTextProtocol {
            // Set the color
            if config.color != nil {
                textProtocol.setCSSTextColor(config.color!)
            }
            
            // Set the font
            if let font = config.font?.getFont() {
                textProtocol.setCSSFont(font)
            }
            
            // Set the alignment
            if let align = config.text?.align {
                textProtocol.setCSSTextAlignment(align)
            }
            
            // Set the overflow
            if let overflow = config.text?.overflow {
                textProtocol.setCSSTextOverflow(overflow)
            }
        }
        
        // Call the custom config callback
        if custom != nil {
            custom!(config)
        }
        
        // If we are snooping, handle it
        if cssManager.snoop || cssManager.classMissing {
            let cssDict = ViewCSSConfig.toCSS(object: self)
            var keyName = className
            if klass != nil {
                keyName += "." + klass!
            }
            cssManager.logSnoop(key: keyName, dict: cssDict)
            if cssManager.classMissing {
                print("Properties for unknown class " + keyName + ":")
                cssManager.printDictionary(dict: cssDict)
            }
        }
    }
}
