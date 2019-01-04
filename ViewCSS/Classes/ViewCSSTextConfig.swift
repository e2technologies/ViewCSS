import Foundation

public class ViewCSSTextConfig: ViewCSSBaseConfig {
    
    public enum Transform {
        case uppercase
        case lowercase
        case capitalize
    }
    
    public enum DecorationLine {
        case underline
        case overline
        case line_through
    }
    
    public private(set) var align: NSTextAlignment?
    public private(set) var overflow: NSLineBreakMode?
    public private(set) var shadow: ViewCSSShadowConfig?
    public private(set) var transform: Transform?
    public private(set) var decorationLine: DecorationLine?
    public private(set) var decorationColor: UIColor?
    public private(set) var decorationStyle: NSUnderlineStyle?
    
    init(css: Dictionary<String, Any>) {
        super.init()
        self.shadow = ViewCSSShadowConfig(css: css, base: "text")
        
        self.align = self.valueFromCSS(
            css, attribute: TEXT_ALIGN, types: [.custom], match: nil)
        { (string: String) -> (Any?) in
            if string == "center" { return NSTextAlignment.center }
            else if string == "left" { return NSTextAlignment.left }
            else if string == "right" { return NSTextAlignment.right }
            else if string == "justify" { return NSTextAlignment.justified }
            return nil
            } as? NSTextAlignment
        
        self.transform = self.valueFromCSS(
            css, attribute: TEXT_TRANSFORM, types: [.custom], match: nil)
        { (string: String) -> (Any?) in
            if string == "uppercase" { return Transform.uppercase }
            else if string == "lowercase" { return Transform.lowercase }
            else if string == "capitalize" { return Transform.capitalize }
            return nil
            } as? Transform
 
        self.overflow = self.valueFromCSS(
            css, attribute: TEXT_OVERFLOW, types: [.custom], match: nil)
        { (string: String) -> (Any?) in
            if string == "clip" { return NSLineBreakMode.byClipping }
            else if string == "ellipsis" { return NSLineBreakMode.byTruncatingTail }
            return nil
            } as? NSLineBreakMode
        
        self.decorationLine = self.valueFromCSS(
            css, attribute: TEXT_DECORATION_LINE, types: [.custom], match: nil)
        { (string: String) -> (Any?) in
            if string == "overline" { return DecorationLine.overline }
            else if string == "underline" { return DecorationLine.underline }
            else if string == "line-through" { return DecorationLine.line_through }
            return nil
            } as? DecorationLine
        
        self.decorationColor = self.valueFromCSS(
            css, attribute: TEXT_DECORATION_COLOR, types: [.color], match: nil) as? UIColor
        
        self.decorationStyle = self.valueFromCSS(
            css, attribute: TEXT_DECORATION_STYLE, types: [.custom], match: nil)
        { (string: String) -> (Any?) in
            if string == "solid" { return NSUnderlineStyle.styleSingle }
            else if string == "double" { return NSUnderlineStyle.styleDouble }
            else if string == "dotted" { return NSUnderlineStyle.patternDot }
            else if string == "dashed" { return NSUnderlineStyle.patternDash }
            return nil
            } as? NSUnderlineStyle
    }
    
    static func toCSS(object: Any) -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if let textProtocol = object as? ViewCSSTextProtocol {
            var align: String? = nil
            switch textProtocol.getCSSTextAlignment() {
            case .center:
                align = "center"
            case .left:
                align = "left"
            case .right:
                align = "right"
            case .justified:
                align = "justify"
            default:
                align = nil
            }
            if align != nil {
                dict[TEXT_ALIGN] = align
            }
            
            if let lineBreakMode = textProtocol.getCSSTextOverflow() {
                var overflow: String? = nil
                switch lineBreakMode {
                case .byClipping:
                    overflow = "clip"
                case .byTruncatingTail:
                    overflow = "ellipsis"
                default:
                    overflow = nil
                }
                if overflow != nil {
                    dict[TEXT_OVERFLOW] = overflow
                }
            }
        }
        
        dict.merge(ViewCSSShadowConfig.toCSS(object: object, base: "text"), uniquingKeysWith: { (current, _) in current })
        
        return dict
    }

}
