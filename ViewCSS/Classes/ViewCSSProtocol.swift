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

public protocol ViewCSSCustomizableProtocol {
    func cssCustomize(object: Any?, class klass: String?, style: String?, config: ViewCSSConfig)
}

protocol ViewCSSProtocol {
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

protocol ViewCSSShadowProtocol: ViewCSSProtocol {
    func setCSSShadow(offset: CGSize, radius: CGFloat?, color: UIColor?, opacity: CGFloat)
    
    func getCSSShadowOffset() -> CGSize?
    func getCSSShadowRadius() -> CGFloat
    func getCSSShadowColor() -> UIColor?
    func getCSSShadowOpacity() -> CGFloat
}

protocol ViewCSSTextProtocol: ViewCSSShadowProtocol {
    func setCSSTextColor(_ color: UIColor)
    func setCSSFont(_ font: UIFont)
    func setCSSTextAlignment( _ alignment: NSTextAlignment)
    
    func getCSSTextColor() -> UIColor?
    func getCSSFont() -> UIFont?
    func getCSSTextAlignment() -> NSTextAlignment
}
