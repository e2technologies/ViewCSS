import Foundation

public class ViewCSSShadowConfig: ViewCSSBaseConfig {
    static let OPACITY_DEFAULT: CGFloat = 1.0
    
    private var base: String?
    public private(set) var hShadow: CGFloat?
    public private(set) var vShadow: CGFloat?
    public private(set) var radius: CGFloat?
    public private(set) var color: UIColor?
    public private(set) var opacity: CGFloat?
    
    init(css: Dictionary<String, Any>, base: String?=nil) {
        super.init()
        self.base = base
        
        self.setAll(css: css)
        
        // For opacity, we only want to override if we found a match
        if let opacity = self.valueFromCSS(
            css,attribute: self.getParam(SHADOW_OPACITY), types:[.number], match: nil) as? CGFloat {
            self.opacity = opacity
        }
    }
    
    private class func getParam(_ param: String, base: String?=nil) -> String {
        if base != nil {
            return base! + "-" + param
        }
        return param
    }
    
    private func getParam(_ param: String) -> String {
        return type(of: self).getParam(param, base: self.base)
    }
    
    func setAll(css: Dictionary<String, Any>) {
        let string = css[self.getParam(SHADOW)] as? String
        
        if string != nil {
            let shadowComponents = string!.split(separator: " ")
            
            // h-shadow v-shadow
            if shadowComponents.count >= 2 {
                self.setHShadow(string: String(shadowComponents[0]))
                self.setVShadow(string: String(shadowComponents[1]))
            }
            else {
                return
            }
            
            // radius
            var index = 2
            if shadowComponents.count > 2 {
                self.setRadius(string: String(shadowComponents[2]))
                if self.radius != nil {
                    index += 1
                }
            }
            
            // color
            if shadowComponents.count > index {
                self.setColor(string: String(shadowComponents[index]))
            }
            
            // opacity
            if self.hShadow != nil && self.vShadow != nil {
                self.opacity = type(of: self).OPACITY_DEFAULT
            }
        }
    }
    
    func setHShadow(string: String) {
        self.hShadow = self.valueFromString(string, types: [.length], match: nil) as? CGFloat
    }
    
    func setVShadow(string: String) {
        self.vShadow = self.valueFromString(string, types: [.length], match: nil) as? CGFloat
    }
    
    func setRadius(string: String) {
        self.radius = self.valueFromString(string, types: [.length], match: nil) as? CGFloat
    }
    
    func setColor(string: String) {
        self.color = self.valueFromString(string, types: [.color], match: nil) as? UIColor
    }

    static func toCSS(object: Any, base: String?=nil) -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if let shadowProtocol = object as? ViewCSSShadowProtocol {
            
            let opacity = shadowProtocol.getCSSShadowOpacity()
            
            // Check for opacity
            if opacity > 0 {
                var shadow = ""
                
                // Print the offset
                if let offset = shadowProtocol.getCSSShadowOffset() {
                    shadow = offset.width.toPX + " " + offset.height.toPX
                }
                
                // Print the radius
                let radius = shadowProtocol.getCSSShadowRadius()
                if radius > 0.0 {
                    shadow += " " + radius.toPX
                }
                
                // Print the color
                if let color = shadowProtocol.getCSSShadowColor() {
                    shadow += " " + color.toCSS
                }
                
                dict[self.getParam(SHADOW, base: base)] = shadow
                
                // Opacity defaults to 1.0.  Explicitely print it if it is different
                if opacity != OPACITY_DEFAULT {
                    dict[self.getParam(SHADOW_OPACITY, base: base)] = opacity.toCSS
                }
            }
        }
        
        return dict
    }
}
