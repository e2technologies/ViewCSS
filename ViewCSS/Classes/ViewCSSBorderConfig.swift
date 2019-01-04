import Foundation

public class ViewCSSBorderConfig: ViewCSSBaseConfig {
    
    public private(set) var radius: CGFloat?
    public private(set) var width: CGFloat?
    public private(set) var color: UIColor?
    
    init(css: Dictionary<String, Any>) {
        super.init()
        
        self.radius = self.valueFromCSS(
            css, attribute: BORDER_RADIUS, types: [.length], match: nil) as? CGFloat
    
        self.color = self.valueFromCSS(
            css, attribute: BORDER_COLOR, types: [.color], match: nil) as? UIColor
        
        self.width = self.valueFromCSS(
            css, attribute: BORDER_WIDTH, types: [.length, .custom], match: nil,
            custom: { (string: String) in
                if string == "medium" { return CGFloat(2) }
                else if string == "thin" { return CGFloat(1) }
                else if string == "thick" { return CGFloat(3) }
                return nil
        }) as? CGFloat
    }

    static func toCSS(object: Any) -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if let viewProtocol = object as? ViewCSSProtocol {
            let borderRadius = viewProtocol.getCSSBorderRadius()
            let borderColor = viewProtocol.getCSSBorderColor()
            let borderWidth = viewProtocol.getCSSBorderWidth()
            
            if borderRadius > 0 {
                dict[BORDER_RADIUS] = borderRadius.toPX
            }
            
            if borderWidth > 0 && borderColor != nil {
                dict[BORDER_WIDTH] = borderWidth.toPX
                dict[BORDER_COLOR] = borderColor!.toCSS
            }
        }
        
        return dict
    }
}
