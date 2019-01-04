import Foundation

public class ViewCSSConfig: ViewCSSBaseConfig {
    
    public private(set) var font: ViewCSSFontConfig?
    public private(set) var border: ViewCSSBorderConfig?
    public private(set) var text: ViewCSSTextConfig?
    public private(set) var background: ViewCSSBackgroundConfig?
    public private(set) var tintColor: UIColor?
    public private(set) var color: UIColor?
    public private(set) var opacity: CGFloat?
    
    init(css: Dictionary<String, Any>) {
        super.init()
        
        self.border = ViewCSSBorderConfig(css: css)
        self.font = ViewCSSFontConfig(css: css)
        self.text = ViewCSSTextConfig(css: css)
        self.background = ViewCSSBackgroundConfig(css: css)
        
        self.tintColor = self.valueFromCSS(
            css, attribute: TINT_COLOR, types: [.color], match: nil) as? UIColor
        
        self.color = self.valueFromCSS(
            css, attribute: COLOR, types: [.color], match: nil) as? UIColor
        
        self.opacity = self.valueFromCSS(
            css, attribute: OPACITY, types:[.number], match: nil) as? CGFloat
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
}

