import Foundation

public protocol ViewCSSCustomizableProtocol {
    func cssCustomize(object: Any?, class klass: String?, style: String?, config: ViewCSSConfig)
}

public protocol ViewCSSProtocol {
    func setCSSBackgroundColor(_ color: UIColor)
    func setCSSTintColor(_ color: UIColor)
    func setCSSBorderRadius(_ radius: CGFloat)
    func setCSSBorder(width: CGFloat, color: UIColor)
    func setCSSOpacity(_ opacity: CGFloat)
    
    func getCSSBackgroundColor() -> UIColor?
    func getCSSTintColor() -> UIColor?
    func getCSSBorderRadius() -> CGFloat
    func getCSSBorderWidth() -> CGFloat
    func getCSSBorderColor() -> UIColor?
    func getCSSOpacity() -> CGFloat
}

public protocol ViewCSSShadowProtocol: ViewCSSProtocol {
    func setCSSShadow(offset: CGSize, radius: CGFloat?, color: UIColor?, opacity: CGFloat)
    
    func getCSSShadowOffset() -> CGSize?
    func getCSSShadowRadius() -> CGFloat
    func getCSSShadowColor() -> UIColor?
    func getCSSShadowOpacity() -> CGFloat
}

public protocol ViewCSSTextProtocol: ViewCSSShadowProtocol {
    func setCSSTextColor(_ color: UIColor)
    func setCSSTextOverflow(_ overflow: NSLineBreakMode)
    func setCSSFont(_ font: UIFont)
    func setCSSTextAlignment( _ alignment: NSTextAlignment)
    
    func getCSSTextColor() -> UIColor?
    func getCSSTextOverflow() -> NSLineBreakMode?
    func getCSSFont() -> UIFont?
    func getCSSTextAlignment() -> NSTextAlignment
}

public protocol ViewCSSGenerateCSSTextProtocol {
    static var shouldIncludeBackgroundColor: Bool { get }
    var cssText: String? { get set }
    var cssAttributedText: NSAttributedString? { get set }
}
