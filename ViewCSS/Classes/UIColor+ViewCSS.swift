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

extension UIColor {
    
    public convenience init?(name: String) {
        let allColors = [
            "aliceblue": "#F0F8FFFF",
            "antiquewhite": "#FAEBD7FF",
            "aqua": "#00FFFFFF",
            "aquamarine": "#7FFFD4FF",
            "azure": "#F0FFFFFF",
            "beige": "#F5F5DCFF",
            "bisque": "#FFE4C4FF",
            "black": "#000000FF",
            "blanchedalmond": "#FFEBCDFF",
            "blue": "#0000FFFF",
            "blueviolet": "#8A2BE2FF",
            "brown": "#A52A2AFF",
            "burlywood": "#DEB887FF",
            "cadetblue": "#5F9EA0FF",
            "chartreuse": "#7FFF00FF",
            "chocolate": "#D2691EFF",
            "coral": "#FF7F50FF",
            "cornflowerblue": "#6495EDFF",
            "cornsilk": "#FFF8DCFF",
            "crimson": "#DC143CFF",
            "cyan": "#00FFFFFF",
            "darkblue": "#00008BFF",
            "darkcyan": "#008B8BFF",
            "darkgoldenrod": "#B8860BFF",
            "darkgray": "#A9A9A9FF",
            "darkgrey": "#A9A9A9FF",
            "darkgreen": "#006400FF",
            "darkkhaki": "#BDB76BFF",
            "darkmagenta": "#8B008BFF",
            "darkolivegreen": "#556B2FFF",
            "darkorange": "#FF8C00FF",
            "darkorchid": "#9932CCFF",
            "darkred": "#8B0000FF",
            "darksalmon": "#E9967AFF",
            "darkseagreen": "#8FBC8FFF",
            "darkslateblue": "#483D8BFF",
            "darkslategray": "#2F4F4FFF",
            "darkslategrey": "#2F4F4FFF",
            "darkturquoise": "#00CED1FF",
            "darkviolet": "#9400D3FF",
            "deeppink": "#FF1493FF",
            "deepskyblue": "#00BFFFFF",
            "dimgray": "#696969FF",
            "dimgrey": "#696969FF",
            "dodgerblue": "#1E90FFFF",
            "firebrick": "#B22222FF",
            "floralwhite": "#FFFAF0FF",
            "forestgreen": "#228B22FF",
            "fuchsia": "#FF00FFFF",
            "gainsboro": "#DCDCDCFF",
            "ghostwhite": "#F8F8FFFF",
            "gold": "#FFD700FF",
            "goldenrod": "#DAA520FF",
            "gray": "#808080FF",
            "grey": "#808080FF",
            "green": "#008000FF",
            "greenyellow": "#ADFF2FFF",
            "honeydew": "#F0FFF0FF",
            "hotpink": "#FF69B4FF",
            "indianred": "#CD5C5CFF",
            "indigo": "#4B0082FF",
            "ivory": "#FFFFF0FF",
            "khaki": "#F0E68CFF",
            "lavender": "#E6E6FAFF",
            "lavenderblush": "#FFF0F5FF",
            "lawngreen": "#7CFC00FF",
            "lemonchiffon": "#FFFACDFF",
            "lightblue": "#ADD8E6FF",
            "lightcoral": "#F08080FF",
            "lightcyan": "#E0FFFFFF",
            "lightgoldenrodyellow": "#FAFAD2FF",
            "lightgray": "#D3D3D3FF",
            "lightgrey": "#D3D3D3FF",
            "lightgreen": "#90EE90FF",
            "lightpink": "#FFB6C1FF",
            "lightsalmon": "#FFA07AFF",
            "lightseagreen": "#20B2AAFF",
            "lightskyblue": "#87CEFAFF",
            "lightslategray": "#778899FF",
            "lightslategrey": "#778899FF",
            "lightsteelblue": "#B0C4DEFF",
            "lightyellow": "#FFFFE0FF",
            "lime": "#00FF00FF",
            "limegreen": "#32CD32FF",
            "linen": "#FAF0E6FF",
            "magenta": "#FF00FFFF",
            "maroon": "#800000FF",
            "mediumaquamarine": "#66CDAAFF",
            "mediumblue": "#0000CDFF",
            "mediumorchid": "#BA55D3FF",
            "mediumpurple": "#9370D8FF",
            "mediumseagreen": "#3CB371FF",
            "mediumslateblue": "#7B68EEFF",
            "mediumspringgreen": "#00FA9AFF",
            "mediumturquoise": "#48D1CCFF",
            "mediumvioletred": "#C71585FF",
            "midnightblue": "#191970FF",
            "mintcream": "#F5FFFAFF",
            "mistyrose": "#FFE4E1FF",
            "moccasin": "#FFE4B5FF",
            "navajowhite": "#FFDEADFF",
            "navy": "#000080FF",
            "oldlace": "#FDF5E6FF",
            "olive": "#808000FF",
            "olivedrab": "#6B8E23FF",
            "orange": "#FFA500FF",
            "orangered": "#FF4500FF",
            "orchid": "#DA70D6FF",
            "palegoldenrod": "#EEE8AAFF",
            "palegreen": "#98FB98FF",
            "paleturquoise": "#AFEEEEFF",
            "palevioletred": "#D87093FF",
            "papayawhip": "#FFEFD5FF",
            "peachpuff": "#FFDAB9FF",
            "peru": "#CD853FFF",
            "pink": "#FFC0CBFF",
            "plum": "#DDA0DDFF",
            "powderblue": "#B0E0E6FF",
            "purple": "#800080FF",
            "rebeccapurple": "#663399FF",
            "red": "#FF0000FF",
            "rosybrown": "#BC8F8FFF",
            "royalblue": "#4169E1FF",
            "saddlebrown": "#8B4513FF",
            "salmon": "#FA8072FF",
            "sandybrown": "#F4A460FF",
            "seagreen": "#2E8B57FF",
            "seashell": "#FFF5EEFF",
            "sienna": "#A0522DFF",
            "silver": "#C0C0C0FF",
            "skyblue": "#87CEEBFF",
            "slateblue": "#6A5ACDFF",
            "slategray": "#708090FF",
            "slategrey": "#708090FF",
            "snow": "#FFFAFAFF",
            "springgreen": "#00FF7FFF",
            "steelblue": "#4682B4FF",
            "tan": "#D2B48CFF",
            "teal": "#008080FF",
            "thistle": "#D8BFD8FF",
            "tomato": "#FF6347FF",
            "turquoise": "#40E0D0FF",
            "violet": "#EE82EEFF",
            "wheat": "#F5DEB3FF",
            "white": "#FFFFFFFF",
            "whitesmoke": "#F5F5F5FF",
            "yellow": "#FFFF00FF",
            "yellowgreen": "#9ACD32FF",
            "transparent": "#00000000",
        ]
        
        let cleanedName = name.replacingOccurrences(of: " ", with: "").lowercased()
        
        if let hexString = allColors[cleanedName] {
            self.init(css: hexString)
        } else {
            return nil
        }
    }
    
    public convenience init?(css: String) {
        
        let newCss = ViewCSSManager.shared.checkForVariable(string: css)
        if newCss == nil { return nil }
        
        var cleanCss = newCss!.replacingOccurrences(of: " ", with: "")
        
        if cleanCss.hasPrefix("#") || cleanCss.hasPrefix("rgb(")  {
            
            var red: CGFloat?
            var green: CGFloat?
            var blue: CGFloat?
            var alpha: CGFloat?
            
            // Parse the HEX value
            if cleanCss.hasPrefix("#") {
                cleanCss = String(cleanCss.dropFirst())
                
                // Ensure there are 8 characters
                while(cleanCss.count < 8) {
                    cleanCss += "F"
                }
                
                red = cleanCss.valueOfHex(start: 0, length: 2)
                green = cleanCss.valueOfHex(start: 2, length: 2)
                blue = cleanCss.valueOfHex(start: 4, length: 2)
                alpha = cleanCss.valueOfHex(start: 6, length: 2)
            }
                // Parse the RGB function method
            else {
                if !cleanCss.hasSuffix(")") { return nil }
                cleanCss = String(cleanCss.dropFirst(4))
                cleanCss = String(cleanCss.dropLast())
                
                var colorComponents = cleanCss.split(separator: ",")
                
                // Ensure there are 4 values
                while(colorComponents.count < 4) {
                    colorComponents.append("255")
                }
                
                // Convert to Float
                var colorFloatComponents = [CGFloat]()
                for colorComponent in colorComponents {
                    if let colorInt = UInt(colorComponent) {
                        colorFloatComponents.append(CGFloat(colorInt))
                    }
                    else {
                        return nil
                    }
                }
                
                red = colorFloatComponents[0]
                green = colorFloatComponents[1]
                blue = colorFloatComponents[2]
                alpha = colorFloatComponents[3]
            }
            
            if red == nil || green == nil || blue == nil || alpha == nil { return nil }
            
            red = red!/255.0
            green = green!/255.0
            blue = blue!/255.0
            alpha = alpha!/255.0
            
            self.init(red: red!, green: green!, blue: blue!, alpha: alpha!)
        }
            
            // Static Color Lookup
        else {
            if let color = UIColor(name: cleanCss) {
                self.init(cgColor: color.cgColor)
            }
            else {
                return nil
            }
        }
    }
    
    public var toCSS: String {
        var red = 255
        var green = 255
        var blue = 255
        var alpha = 255
        
        if let colors = self.cgColor.components {
            if self.cgColor.numberOfComponents >= 3 {
                // Have RGB value
                red = Int(255 * colors[0])
                green = Int(255 * colors[1])
                blue = Int(255 * colors[2])
                alpha = self.cgColor.numberOfComponents == 4 ? Int(255 * colors[3]) : 255
            }
            else {
                // Have Grayscale value
                red = Int(255 * colors[0])
                green = Int(255 * colors[0])
                blue = Int(255 * colors[0])
                alpha = self.cgColor.numberOfComponents == 2 ? Int(255 * colors[1]) : 255
            }
        }
        
        return String(format:"#%02X%02X%02X%02X", red, green, blue, alpha)
    }
}
