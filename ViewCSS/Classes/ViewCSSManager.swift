//
//  ViewCSSManager.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/29/17.
//

import Foundation

public class ViewCSSManager {
    
    // Supported Tags
    let BACKGROUND_COLOR = "background-color"
    let COLOR = "color"
    let FONT_SIZE = "font-size"
    let FONT_WEIGHT = "font-weight"
    let TEXT_ALIGN = "text-align"
    
    var styleCache = [String:ViewCSSStyleConfig]()
    
    public var styleLookup = Dictionary<String, Any>() {
        didSet {
            self.styleCache.removeAll()
        }
    }
    
    public static var shared: ViewCSSManager = {
        return ViewCSSManager()
    }()
    
    func getConfig(object: Any, style: String?) -> ViewCSSStyleConfig {
        let klassName = self.getKlassName(object: object)
        
        // Create the cache key
        let cacheKey: String
        if style == nil || style!.isEmpty {
            cacheKey = klassName
        }
        else {
            cacheKey = style! + " " + klassName
        }
        
        // Return the config value if it is already in the cache
        if let cachedConfig = self.styleCache[cacheKey] {
            return cachedConfig
        }
        
        // Create a merged dictionary with all of the values
        var mergedDictionary = Dictionary<String, Any>()
        
        // If this contains a ":", then it is inline style
        if style!.contains(":") {
            // Remove the whitespace
            let inlineStyle = style!.trimmingCharacters(in: .whitespaces)
            
            // Break the inline into components and set as values in the dictionary
            for subStyle in inlineStyle.split(separator: ";") {
                let components = subStyle.split(separator: ":")
                if components.count != 2 { continue }
                mergedDictionary[String(components[0])] = String(components[1])
            }
        }
            // Else it is a list of classes.  Parse them
        else {
            // Get the list
            for subStyle in style!.split(separator: " ") {
                // Look for the class by itself and the class with a "."
                for name in [String(klassName + "." + subStyle), String("."+subStyle)] {
                    // If we find a match, merge it into the dictionary
                    if let subDict = self.styleLookup[name] as? Dictionary<String, Any> {
                        mergedDictionary = mergedDictionary.merging(subDict) { (current, _) in current }
                    }
                }
            }
        }
        
        // Lastly, see if there is a class by itself
        if let subDict = self.styleLookup[klassName] as? Dictionary<String, Any> {
            mergedDictionary = mergedDictionary.merging(subDict) { (current, _) in current }
        }
        
        // Now parse the final dictionary and return it to the user
        let config = self.parseStyleDictionary(mergedDictionary)
        self.styleCache[cacheKey] = config
        return config
    }
    
    private func getKlassName(object: Any) -> String {
        return String(describing: type(of: object)).camelToSnake
    }
    
    private func parseStyleDictionary(_ dict: Dictionary<String, Any>) -> ViewCSSStyleConfig {
        let config = ViewCSSStyleConfig()
        
        config.cssBackgroundColor(string: dict[BACKGROUND_COLOR] as? String)
        config.cssColor(string: dict[COLOR] as? String)
        config.cssFontSize(string: dict[FONT_SIZE] as? String)
        config.cssFontWeightValue(string: dict[FONT_WEIGHT] as? String)
        config.cssTextAlign(string: dict[TEXT_ALIGN] as? String)
 
        return config
    }
}
