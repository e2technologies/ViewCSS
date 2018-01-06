/*
 Copyright 2018 Eric Chapman
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this
 software and associated documentation files (the "Software"), to deal in the Software
 without restriction, including without limitation the rights to use, copy, modify,
 merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be included in all copies
 or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
 OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
