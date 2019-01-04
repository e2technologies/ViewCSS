
import Foundation

extension CGFloat {
    var toPX : String {
        return String(format: "%dpx", Int(self.rounded()))
    }
    
    var toCSS : String {
        return String(format: "%g", self)
    }
}
