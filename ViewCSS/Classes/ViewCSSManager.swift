//
//  ViewCSSManager.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/29/17.
//

import Foundation

public class ViewCSSManager {
    
    private var styleCache = [String:ViewCSSStyleConfig]()
    
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
    
    func getConfig(object: Any, style: String?, class klass: String?) -> ViewCSSStyleConfig {
        let klassName = self.getKlassName(object: object)
        let cacheKey = self.getCacheKey(klassName: klassName, style: style, class: klass)
        
        // Return the config value if it is already in the cache
        if let cachedConfig = self.styleCache[cacheKey] {
            return cachedConfig
        }
        
        // Create the consolidated dictionary
        let dict = self.generateStyleDictionary(klassName: klassName, style: style, class: klass)
        
        // Now parse the final dictionary and return it to the user
        let config = ViewCSSStyleConfig.fromCSS(dict: dict)
        self.styleCache[cacheKey] = config
        return config
    }
    
    private func getKlassName(object: Any) -> String {
        return String(describing: type(of: object)).camelToSnake
    }

    private func getCacheKey(klassName: String, style: String?, class klass: String?) -> String {
        var cacheKey = klassName
        if style != nil && !style!.isEmpty {
            cacheKey += " " + style!
        }
        if klass != nil && !klass!.isEmpty {
            cacheKey += " " + klass!
        }
        
        return cacheKey
    }
    
    private func generateStyleDictionary(klassName: String, style: String?, class klass: String?) -> Dictionary<String, Any> {
        
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
            // Get the list
            for subStyle in klass!.split(separator: " ") {
                // Look for the class by itself and the class with a "."
                for name in [String(klassName + "." + subStyle), String("."+subStyle)] {
                    // If we find a match, merge it into the dictionary
                    if let subDict = self.styleLookup[name] as? Dictionary<String, Any> {
                        dict = dict.merging(subDict) { (current, _) in current }
                    }
                }
            }
        }
        
        // Priority 3: General class defines
        if let subDict = self.styleLookup[klassName] as? Dictionary<String, Any> {
            dict = dict.merging(subDict) { (current, _) in current }
        }
        
        return dict
    }
}
