//
//  ViewCSSManager.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/29/17.
//

import Foundation

public class ViewCSSManager {
    
    private var styleCache = [String:ViewCSSConfig]()
    
    private var styleLookup = Dictionary<String, Any>() {
        didSet {
            self.styleCache.removeAll()
        }
    }
    
    private var styleLookupRoot: Dictionary<String, Any>? {
        return self.styleLookup[":root"] as? Dictionary<String, Any>
    }
    
    public func setCSS(dict: Dictionary<String, Any>) {
        self.styleLookup = dict
    }
    
    public static var shared: ViewCSSManager = {
        return ViewCSSManager()
    }()
    
    func checkForVariable(string: String?) -> String? {
        if self.styleLookupRoot == nil { return string }
        if string == nil { return nil }
        
        var nextString = string
        
        // Repeat while the next one is not nil and has a "var" prefix
        repeat {
            // Trim the white space off of the next string
            var newString = nextString!.trimmingCharacters(in: .whitespaces)
            
            // If it starts with "var(", perform the lookup
            if newString.hasPrefix("var(") {
                
                // Strip the var parameteres
                newString = String(newString.dropFirst(4))
                newString = String(newString.dropLast(1))
                
                // Get the next one
                nextString = self.styleLookupRoot![newString] as? String
            }
        } while nextString != nil && nextString!.hasPrefix("var(")
        
        return nextString
    }
    
    func getConfig(cacheKey: String) -> ViewCSSConfig? {
        return self.styleCache[cacheKey]
    }

    func getConfig(className: String, style: String?, class klass: String?) -> ViewCSSConfig {
        let cacheKey = self.getCacheKey(className: className, style: style, class: klass)
        
        // Return the config value if it is already in the cache
        if let cachedConfig = self.getConfig(cacheKey: cacheKey) { return cachedConfig }
        
        // Create the consolidated dictionary
        let dict = self.generateStyleDictionary(className: className, style: style, class: klass)
        
        // Now parse the final dictionary and return it to the user
        let config = ViewCSSConfig.fromCSS(dict: dict)
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
    
    func getClassName(object: Any) -> String {
        return String(describing: type(of: object)).camelToSnake
    }
    
    private func generateStyleDictionary(className: String, style: String?, class klass: String?) -> Dictionary<String, Any> {
        
        // Create a merged dictionary with all of the values
        var dict = Dictionary<String, Any>()
        
        // Priority 1: Style attributes
        if style != nil {
            // Remove the whitespace
            let inlineStyle = style!.trimmingCharacters(in: .whitespaces)
            
            // Break the inline into components and set as values in the dictionary
            for subStyle in inlineStyle.split(separator: ";") {
                let components = subStyle.split(separator: ":")
                if components.count != 2 { continue }
                dict[String(components[0])] = String(components[1])
            }
        }
        
        // Priority 2: Classes
        if klass != nil {
            var numberOfMatches: Int = 0
            
            // Get the list
            for subStyle in klass!.split(separator: " ") {
                // Look for the class by itself and the class with a "."
                for name in [String(className + "." + subStyle), String("."+subStyle)] {
                    // If we find a match, merge it into the dictionary
                    if let subDict = self.styleLookup[name] as? Dictionary<String, Any> {
                        numberOfMatches += 1
                        dict = dict.merging(subDict) { (current, _) in current }
                    }
                }
            }
            
            // If we didn't find any matches, print a message
            if numberOfMatches == 0 {
                print("ViewCSSManager WARN: No match found for CSS class '" + klass! +
                    "' referenced from the object of type '" + className + "'")
            }
        }
        
        // Priority 3: General class defines
        if let subDict = self.styleLookup[className] as? Dictionary<String, Any> {
            dict = dict.merging(subDict) { (current, _) in current }
        }
        
        return dict
    }
}
