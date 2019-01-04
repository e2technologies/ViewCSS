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
