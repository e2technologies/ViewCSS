import Foundation

extension UITextView: ViewCSSTextProtocol {
    func setCSSTextColor(_ color: UIColor) { self.textColor = color }
    func setCSSTextOverflow(_ overflow: NSLineBreakMode) {}
    func setCSSFont(_ font: UIFont) { self.font = font }
    func setCSSTextAlignment( _ alignment: NSTextAlignment) { self.textAlignment = alignment }
    
    func getCSSTextColor() -> UIColor? { return self.textColor }
    func getCSSTextOverflow() -> NSLineBreakMode? { return nil }
    func getCSSFont() -> UIFont? { return self.font }
    func getCSSTextAlignment() -> NSTextAlignment { return self.textAlignment }
}

extension UITextView: ViewCSSShadowProtocol {
    func setCSSShadow(offset: CGSize, radius: CGFloat?, color: UIColor?, opacity: CGFloat) {
        let view = self
        view.layer.shadowOffset = offset
        if radius != nil { view.layer.shadowRadius = radius! }
        if color != nil { view.layer.shadowColor = color!.cgColor }
        view.layer.shadowOpacity = Float(opacity)
    }
    
    func getCSSShadowOffset() -> CGSize? { return self.layer.shadowOffset }
    func getCSSShadowRadius() -> CGFloat { return self.layer.shadowRadius }
    func getCSSShadowColor() -> UIColor? { return self.layer.shadowColor != nil ? UIColor(cgColor: self.layer.shadowColor!) : nil }
    func getCSSShadowOpacity() -> CGFloat { return CGFloat(self.layer.shadowOpacity) }
}

extension UITextView: ViewCSSGenerateCSSTextProtocol {
    public static var shouldIncludeBackgroundColor: Bool { return true }
    
    public var cssText: String? {
        get { return self.cssAttributedText?.string }
        set { self.cssAttributedText = newValue?.cssText(object: self) }
    }
    
    public var cssAttributedText: NSAttributedString? {
        get { return self.attributedText }
        set { self.attributedText = newValue }
    }
}
