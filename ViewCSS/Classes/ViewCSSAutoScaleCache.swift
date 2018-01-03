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
            self.scale = 0.8
        case .small:
            self.scale = 0.9
        case .medium:
            self.scale = 1.0
        case .large:
            self.scale = 1.1
        case .extraLarge:
            self.scale = 1.2
        case .extraExtraLarge:
            self.scale = 1.3
        case .extraExtraExtraLarge:
            self.scale = 1.4
        case .accessibilityMedium:
            self.scale = 1.5
        case .accessibilityLarge:
            self.scale = 1.6
        case .accessibilityExtraLarge:
            self.scale = 1.7
        case .accessibilityExtraExtraLarge:
            self.scale = 1.8
        case .accessibilityExtraExtraExtraLarge:
            self.scale = 1.8
        default:
            self.scale = 1.0
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
