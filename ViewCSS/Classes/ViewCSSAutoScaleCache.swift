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

class ViewCSSAutoScaleCache {
    public static var shared: ViewCSSAutoScaleCache = {
        return ViewCSSAutoScaleCache()
    }()
    
    var scale: CGFloat = 1.0
    
    @objc func updateScale() {
        switch UIApplication.shared.preferredContentSizeCategory {
        case .extraSmall:
            self.scale = 0.70
        case .small:
            self.scale = 0.85
        case .medium:
            self.scale = 1.00
        case .large:
            self.scale = 1.15
        case .extraLarge:
            self.scale = 1.30
        case .extraExtraLarge:
            self.scale = 1.45
        case .extraExtraExtraLarge:
            self.scale = 1.60
        case .accessibilityMedium:
            self.scale = 1.75
        case .accessibilityLarge:
            self.scale = 1.90
        case .accessibilityExtraLarge:
            self.scale = 2.05
        case .accessibilityExtraExtraLarge:
            self.scale = 2.20
        case .accessibilityExtraExtraExtraLarge:
            self.scale = 2.35
        default:
            self.scale = 2.50
        }
        
        // Clear the View Manager Cache since the scale was updated
        ViewCSSManager.shared.clearCache()
    }
    
    init() {
        self.updateScale()
        
        // Subscribe to update notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateScale),
                                               name: NSNotification.Name.UIContentSizeCategoryDidChange,
                                               object: nil)
    }
}
