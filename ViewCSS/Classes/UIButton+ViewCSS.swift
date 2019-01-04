import Foundation

extension UIButton: ViewCSSTextProtocol {
    func setCSSTextColor(_ color: UIColor) { self.setTitleColor(color, for: .normal) }
    func setCSSTextOverflow(_ overflow: NSLineBreakMode) {
        self.titleLabel?.adjustsFontSizeToFitWidth = false
        self.titleLabel?.lineBreakMode = overflow
    }
    func setCSSFont(_ font: UIFont) { self.titleLabel?.font = font }
    func setCSSTextAlignment( _ alignment: NSTextAlignment) {
        if alignment == .left {
            self.contentHorizontalAlignment = .left
        }
        else if alignment == .right {
            self.contentHorizontalAlignment = .right
        }
        else {
            self.contentHorizontalAlignment = .center
        }
    }
    
    func getCSSTextColor() -> UIColor? { return self.titleColor(for: .normal) }
    func getCSSTextOverflow() -> NSLineBreakMode? { return self.titleLabel?.lineBreakMode }
    func getCSSFont() -> UIFont? { return self.titleLabel?.font }
    func getCSSTextAlignment() -> NSTextAlignment {
        if self.contentHorizontalAlignment == .left {
            return .left
        }
        else if self.contentHorizontalAlignment == .right {
            return .right
        }
        else {
            return .center
        }
    }
}

extension UIButton: ViewCSSShadowProtocol {
    func setCSSShadow(offset: CGSize, radius: CGFloat?, color: UIColor?, opacity: CGFloat) {
        if let view = self.titleLabel {
            view.layer.shadowOffset = offset
            if radius != nil { view.layer.shadowRadius = radius! }
            if color != nil { view.layer.shadowColor = color!.cgColor }
            view.layer.shadowOpacity = Float(opacity)
        }
    }
    
    func getCSSShadowOffset() -> CGSize? { return self.titleLabel?.layer.shadowOffset }
    func getCSSShadowRadius() -> CGFloat { return self.titleLabel?.layer.shadowRadius ?? 0.0 }
    func getCSSShadowColor() -> UIColor? { return self.titleLabel?.layer.shadowColor != nil ? UIColor(cgColor: self.layer.shadowColor!) : nil }
    func getCSSShadowOpacity() -> CGFloat { return CGFloat(self.titleLabel?.layer.shadowOpacity ?? 0.0) }
}

extension UIButton: ViewCSSGenerateCSSTextProtocol {
    public static var shouldIncludeBackgroundColor: Bool { return false }
    
    public var cssText: String? {
        get { return self.cssAttributedText?.string }
        set { self.cssAttributedText = newValue?.cssText(object: self) }
    }
    
    public var cssAttributedText: NSAttributedString? {
        get { return self.attributedTitle(for: .normal) }
        set { self.setAttributedTitle(newValue, for: .normal) }
    }
}
