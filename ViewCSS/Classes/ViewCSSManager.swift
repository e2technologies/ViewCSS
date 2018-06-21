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

public class ViewCSSManager {
    
    // Snoop Feature Logic
    public var snoop = false
    private var snoopDict = Dictionary<String, Any>()
    func logSnoop(key: String, dict: Dictionary<String, Any>) {
        self.snoopDict[key] = dict
    }
    public func printSnoop() {
        self.printDictionary(dict: self.snoopDict)
    }
    func printDictionary(dict: Dictionary<String, Any>) {
        let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        dump(string!)
    }
    
    // Mark missing class error
    var classMissing = false
    
    // Ths method sets the manager with the CSS
    public func setCSS(dict: Dictionary<String, Any>) {
        self.styleLookup = dict
    }
    
    // This method returns a singleton for the manger
    public static var shared: ViewCSSManager = {
        return ViewCSSManager()
    }()
    
    // This methods will check the CSS lookup for a variable
    func checkForVariable(string: String?) -> String? {
        if self.styleLookupRoot == nil { return string }
        if string == nil { return nil }
        
        var nextString = string
        
        // Repeat while the next one is not nil and has a "var" prefix
        repeat {
            // Trim the white space off of the next string
            var newString = nextString!.trimmingCharacters(in: .whitespaces)
            
            // If it starts with "var(", perform the lookup
            if newString.hasPrefix("var(") && newString.hasSuffix(")") {
                
                // Strip the var parameteres
                newString = String(newString.dropFirst(4))
                newString = String(newString.dropLast(1))
                
                // Get the next one
                nextString = self.styleLookupRoot![newString] as? String
            }
        } while nextString != nil && nextString!.hasPrefix("var(") && nextString!.hasSuffix(")")
        
        return nextString
    }

    func getConfig(className: String, class klass: String?, style: String?, parentObject: UIView?=nil) -> ViewCSSConfig {
        return self.getConfig(className: className,
                              class: klass,
                              style: style,
                              parentClass: parentObject?.cssClass,
                              parentStyle: parentObject?.cssStyle)
    }
    
    func getConfig(className: String,
                   class klass: String?,
                   style: String?,
                   parentClass: String?,
                   parentStyle: String?) -> ViewCSSConfig {
        
        // Combine the parent/child class
        var cacheClass = klass ?? ""
        if parentClass != nil && parentClass!.count > 0 {
            if cacheClass.count > 0 { cacheClass += " " }
            cacheClass += parentClass!
        }
        
        // Combine the parent/child Style
        var cacheStyle = style ?? ""
        if parentStyle != nil && parentStyle!.count > 0 {
            if cacheStyle.count > 0 { cacheStyle += " " }
            cacheStyle += parentStyle!
        }
        
        // Get the cache key
        let cacheKey = self.getCacheKey(className: className, style: cacheStyle, class: cacheClass)
        
        // Return the config value if it is already in the cache
        if let cachedConfig = self.styleCache[cacheKey] { return cachedConfig }
        
        // Create the consolidated dictionary
        let css = self.generateCSSDictionary(
            className: className,
            style: style,
            class: klass,
            parentClass: parentClass,
            parentStyle: parentStyle)
        
        // Now parse the final dictionary and return it to the user
        let config = ViewCSSConfig(css: css)
        self.styleCache[cacheKey] = config
        return config
    }

    func getCacheKey(className: String, style: String?, class klass: String?) -> String {
        var cacheKey = className
        if style != nil && !style!.isEmpty {
            cacheKey += " " + style!
        }
        if klass != nil && !klass!.isEmpty {
            cacheKey += " " + klass!
        }
        
        return cacheKey
    }
    
    func clearCache() {
        self.styleCache.removeAll()
    }
    
    func getClassName(object: Any) -> String {
        return self.getClassName(class: type(of: object))
    }
    
    func getClassName(class klass: Any.Type) -> String {
        return String(describing: klass).camelToSnake
    }
    
    private var styleCache = [String:ViewCSSConfig]()
    
    private var styleLookup = Dictionary<String, Any>() {
        didSet {
            self.clearCache()
        }
    }
    
    private var styleLookupRoot: Dictionary<String, Any>? {
        return self.styleLookup[":root"] as? Dictionary<String, Any>
    }
    
    func generateClassList(className: String,
                           class klass: String?,
                           parentClass: String?=nil) -> [String] {
        
        var classList = [String]()
        
        let combinedClass = (klass ?? "") + " " + (parentClass ?? "")
        
        for subClass in combinedClass.split(separator: " ") {
            if subClass.isEmpty { continue }
            
            classList.append(String(className + "." + subClass))
            classList.append(String("."+subClass))
        }
        
        classList.append(className)
        
        return classList
    }
    
    func generateCSSDictionary(className: String,
                               style: String?,
                               class klass: String?,
                               parentClass: String?,
                               parentStyle: String?) -> Dictionary<String, Any> {
        
        var dict = Dictionary<String, Any>()
        
        // Priority 1: Style attributes
        let styles = (style ?? "") + ";" + (parentStyle ?? "")
        dict = dict.merging(styles.parseStyle()) { (current, _) in current }

        // Priority 2: Classes
        let classList = self.generateClassList(
            className: className,
            class: klass,
            parentClass: parentClass)
        
        // Iterate through the list and generate the dictionary
        var numberOfMatches: Int = 0
        for key in classList {
            if let subDict = self.styleLookup[key] as? Dictionary<String, Any> {
                numberOfMatches += 1
                dict = dict.merging(subDict) { (current, _) in current }
            }
        }
        
        // If we didn't find any matches, print a message
        if klass != nil && numberOfMatches == 0 {
            print("ViewCSSManager WARN: No match found for CSS class '" + klass! +
                "' referenced from the object of type '" + className + "'")
            self.classMissing = true
        }
        
        return dict
    }
    
    func generateAttributedString(parentObject: Any?,
                                  text: String?,
                                  shouldIncludeBackgroundColor: Bool=true) -> NSAttributedString? {
        if let view = parentObject as? UIView {
            return self.generateAttributedString(parentClassName: view.cssClassName,
                                                 parentClass: view.cssClass,
                                                 parentStyle: view.cssStyle,
                                                 text: text,
                                                 shouldIncludeBackgroundColor: shouldIncludeBackgroundColor)
        }
        else {
            return self.generateAttributedString(parentClassName: nil,
                                                 parentClass: nil,
                                                 parentStyle: nil,
                                                 text: text,
                                                 shouldIncludeBackgroundColor: shouldIncludeBackgroundColor)
        }
    }
    
    func generateAttributedString(parentClassName: String?,
                                  parentClass: String?,
                                  parentStyle: String?,
                                  text: String?,
                                  shouldIncludeBackgroundColor: Bool=true) -> NSAttributedString? {
        
        class ParsedTextContainer {
            var text: String?
            var tag: String?
            var attributes: Dictionary<String, String>?
            var range: NSRange?
            var config: ViewCSSConfig?
        }
        
        if text == nil { return nil }
            
        // Get the stored parameters for the object
        let className = parentClassName ?? ""
        
        // Iterate over the text and generate the attributed string.  Need to
        // parse out the "span" tags
        var parsedText = ""
        var parsedContainers = [ParsedTextContainer]()
        text!.extractTags(callback: { (body: String?, tag: String?, attributes: Dictionary<String, String>) in
            var cleanBody = body?.fromSafeCSS ?? ""
            
            // Get the config
            let config = self.getConfig(
                className: className,
                class: attributes["class"],
                style: attributes["style"],
                parentClass: parentClass,
                parentStyle: parentStyle)
            
            // Need to check the text-transform here to change the body if necessary
            if let transform = config.text?.transform {
                if transform == .capitalize { cleanBody = cleanBody.capitalized }
                else if transform == .lowercase { cleanBody = cleanBody.lowercased() }
                else if transform == .uppercase { cleanBody = cleanBody.uppercased() }
            }
            
            // Create the object to store the attributes
            let textContainer = ParsedTextContainer()
            textContainer.text = cleanBody
            textContainer.tag = tag
            textContainer.attributes = attributes
            textContainer.range = NSRange(location: parsedText.utf16.count, length: cleanBody.utf16.count)
            textContainer.config = config
            
            // Add the details for setting up the attributed string
            parsedContainers.append(textContainer)
            
            // Get the parsed out text
            parsedText += cleanBody
        })
            
        // We have the text.  Iterate through the configs and ranges and decide what to do
        let attributedString = NSMutableAttributedString(string: parsedText)
        for parsedContainer in parsedContainers {
            var attributes = Dictionary<NSAttributedStringKey, Any>()
            
            // Check for a foreground color
            if let color = parsedContainer.config?.color {
                attributes[NSAttributedStringKey.foregroundColor] = color
            }
            
            // Check for a background color
            if let color = parsedContainer.config?.background?.color, shouldIncludeBackgroundColor == true {
                attributes[NSAttributedStringKey.backgroundColor] = color
            }
            
            // Check for a font
            if let font = parsedContainer.config?.font?.getFont() {
                attributes[NSAttributedStringKey.font] = font
            }
            
            // Check for a shadow
            if let textShadow = parsedContainer.config?.text?.shadow {
                if textShadow.hShadow != nil && textShadow.vShadow != nil {
                    let shadow = NSShadow()
                    shadow.shadowOffset = CGSize(width: textShadow.hShadow!, height: textShadow.vShadow!)
                    if textShadow.color != nil { shadow.shadowColor = textShadow.color }
                    if textShadow.radius != nil { shadow.shadowBlurRadius = textShadow.radius! }
                    attributes[NSAttributedStringKey.shadow] = shadow
                }
            }
            
            // Check for a link
            if parsedContainer.tag == "a", let href = parsedContainer.attributes!["href"] {
                attributes[NSAttributedStringKey.link] = href
            }
            
            // Check for decoration
            if let line = parsedContainer.config?.text?.decorationLine {
                
                // Calculate the style based on the settings
                var style = parsedContainer.config?.text?.decorationStyle
                if style == nil {
                    style = NSUnderlineStyle.styleSingle
                }
                var rawStyle = style!.rawValue
                
                if style == NSUnderlineStyle.patternDash || style == NSUnderlineStyle.patternDot {
                    rawStyle |= NSUnderlineStyle.styleSingle.rawValue
                }
                
                // Choose whether underline, overline, or line-through
                if line == .underline {
                    
                    attributes[NSAttributedStringKey.underlineStyle] = rawStyle
                    if let color = parsedContainer.config?.text?.decorationColor {
                        attributes[NSAttributedStringKey.underlineColor] = color
                    }
                }
                else if line == .overline {
                    // TODO: Unsupported
                }
                else if line == .line_through {
                    attributes[NSAttributedStringKey.strikethroughStyle] = rawStyle
                    if let color = parsedContainer.config?.text?.decorationColor {
                        attributes[NSAttributedStringKey.strikethroughColor] = color
                    }
                }
            }
            
            // Set the value
            attributedString.addAttributes(attributes, range: parsedContainer.range!)
        }
        
        return attributedString
    }
}
