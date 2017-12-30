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
        
        var newString = string!.trimmingCharacters(in: .whitespaces)
        if newString.hasPrefix("var(") {
            newString = String(newString.dropFirst(4))
            newString = String(newString.dropLast(1))
            return (self.styleLookupRoot![newString] as? String) ?? string
        }
        return string
    }
    
    func getConfig(cacheKey: String) -> ViewCSSConfig? {
        return self.styleCache[cacheKey]
    }

    func getConfig(object: Any, style: String?, class klass: String?) -> ViewCSSConfig {
        let cacheKey = self.getCacheKey(object: object, style: style, class: klass)
        
        // Return the config value if it is already in the cache
        if let cachedConfig = self.getConfig(cacheKey: cacheKey) { return cachedConfig }
        
        // Create the consolidated dictionary
        let dict = self.generateStyleDictionary(object: object, style: style, class: klass)
        
        // Now parse the final dictionary and return it to the user
        let config = ViewCSSConfig.fromCSS(dict: dict)
        self.styleCache[cacheKey] = config
        return config
    }

    func getCacheKey(object: Any, style: String?, class klass: String?) -> String {
        let klassName = self.getKlassName(object: object)
        var cacheKey = klassName
        if style != nil && !style!.isEmpty {
            cacheKey += " " + style!
        }
        if klass != nil && !klass!.isEmpty {
            cacheKey += " " + klass!
        }
        
        return cacheKey
    }
    
    private func getKlassName(object: Any) -> String {
        return String(describing: type(of: object)).camelToSnake
    }
    
    private func generateStyleDictionary(object: Any, style: String?, class klass: String?) -> Dictionary<String, Any> {
        let klassName = self.getKlassName(object: object)
        
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
                for name in [String(klassName + "." + subStyle), String("."+subStyle)] {
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
                    "' referenced from the an object of type '" + String(describing: type(of: object)) + "'")
            }
        }
        
        // Priority 3: General class defines
        if let subDict = self.styleLookup[klassName] as? Dictionary<String, Any> {
            dict = dict.merging(subDict) { (current, _) in current }
        }
        
        return dict
    }
}
