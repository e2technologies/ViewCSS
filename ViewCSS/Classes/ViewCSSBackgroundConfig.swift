import Foundation

public class ViewCSSBackgroundConfig: ViewCSSBaseConfig {
    
    public private(set) var color: UIColor?
    
    init(css: Dictionary<String, Any>) {
        super.init()
        
        self.color = self.valueFromCSS(
            css, attribute: BACKGROUND_COLOR, types: [.color], match: nil) as? UIColor
    }
    
    static func toCSS(object: Any) -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if let viewProtocol = object as? ViewCSSProtocol {
            if let backgroundColor = viewProtocol.getCSSBackgroundColor() {
                dict[BACKGROUND_COLOR] = backgroundColor.toCSS
            }
        }
        
        return dict
    }

}
