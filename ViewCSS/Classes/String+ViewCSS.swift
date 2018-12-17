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

extension String {
    var fromSafeCSS: String {
        return self.replacingOccurrences(of: "&gt;", with: ">").replacingOccurrences(of: "&lt;", with: "<")
    }
    
    public var toSafeCSS: String {
        return self.replacingOccurrences(of: ">", with: "&gt;").replacingOccurrences(of: "<", with: "&lt;")
    }
    
    // ================================================================
    // Methods to convert the string into CSS Text
    // ================================================================
    
    public func cssText(object: UIView) -> NSAttributedString? {
        
        // Get the should include value
        var shouldIncludeBackgroundColor = true
        if let cssProtocol = object as? ViewCSSGenerateCSSTextProtocol {
            shouldIncludeBackgroundColor = type(of: cssProtocol).shouldIncludeBackgroundColor
        }
        
        // Call the text method
        return self.cssText(
            parentClassName: object.cssClassName,
            class: object.cssClass,
            style: object.cssStyle,
            shouldIncludeBackgroundColor: shouldIncludeBackgroundColor)
    }
    
    public func cssText(parentClass: Any.Type, shouldIncludeBackgroundColor: Bool=true) -> NSAttributedString? {
        return self.cssText(
            parentClass: parentClass,
            class: nil,
            style: nil,
            shouldIncludeBackgroundColor: shouldIncludeBackgroundColor)
    }
    
    public func cssText(parentClass: Any.Type, class klass: String?, shouldIncludeBackgroundColor: Bool=true) -> NSAttributedString? {
        return self.cssText(
            parentClass: parentClass,
            class: klass,
            style: nil,
            shouldIncludeBackgroundColor: shouldIncludeBackgroundColor)
    }
    
    public func cssText(parentClass: Any.Type, style: String?, shouldIncludeBackgroundColor: Bool=true) -> NSAttributedString? {
        return self.cssText(
            parentClass: parentClass,
            class: nil,
            style: style,
            shouldIncludeBackgroundColor: shouldIncludeBackgroundColor)
    }
    
    public func cssText(parentClass: Any.Type, class klass: String?, style: String?, shouldIncludeBackgroundColor: Bool=true) -> NSAttributedString? {
        // Get the parent class name
        let parentClassName = ViewCSSManager.shared.getClassName(class: parentClass)
        
        // Generate the attributed string
        return self.cssText(
            parentClassName: parentClassName,
            class: klass,
            style: style,
            shouldIncludeBackgroundColor: shouldIncludeBackgroundColor)
    }
    
    func cssText(parentClassName: String?, class klass: String?, style: String?, shouldIncludeBackgroundColor: Bool=true) -> NSAttributedString? {
        // Generate the attributed string
        return ViewCSSManager.shared.generateAttributedString(
            parentClassName: parentClassName,
            parentClass: klass,
            parentStyle: style,
            text: self,
            shouldIncludeBackgroundColor: shouldIncludeBackgroundColor)
    }
    
    // ================================================================
    // Converts camel case to snake
    // ================================================================
    
    var camelToSnake: String {
        var newString = ""
        var temp = ""
        
        for index in self.indices {
            let str = String(self[index])
            if str.lowercased() != str {
                temp += str
            }
            else {
                if temp.count > 0 {
                    if newString.count > 0 { newString += "_" }
                    
                    if temp.count > 1 {
                        newString += temp.dropLast().lowercased() + "_" + temp.dropFirst(temp.count-1).lowercased() + str
                    }
                    else {
                        newString += temp.lowercased() + str
                    }
                    
                    temp = ""
                }
                else {
                    newString += str
                }
            }
        }
        
        if temp.count > 0 {
            if newString.count > 0 { newString += "_" }
            
            newString += temp.lowercased()
            
            temp = ""
        }
        
        return newString
    }
    
    func valueOfHex(start: Int, length: Int) -> CGFloat? {
        if start < 0 || start > self.count || (start + length) > self.count { return nil }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: (start+length))
        let hexString = String(self[startIndex..<endIndex])
        return hexString.hexToFloat
    }
    
    var hexToFloat: CGFloat? {
        if let hexInt = UInt(self, radix: 16) {
            return CGFloat(hexInt)
        }
        else {
            return nil
        }
    }
    
    var percentageToFloat: CGFloat? {
        if self.hasSuffix("%") {
            let precentString = dropLast(1)
            if let percentInt = UInt(precentString) {
                return CGFloat(percentInt)/100.0
            }
        }
        return nil
    }
    
    var lengthToFloat: CGFloat? {
        if self.hasSuffix("px") {
            let lengthString = dropLast(2)
            if let lengthInt = UInt(lengthString) {
                return CGFloat(lengthInt)
            }
        }
        return nil
    }
    
    var numberToFloat: CGFloat? {
        if let numberDouble = NumberFormatter().number(from: self) {
            return CGFloat(truncating: numberDouble)
        }
        return nil
    }
    
    // Parses a style attribute into the CSS properties and values
    func parseStyle() -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        // Remove the whitespace
        let inlineStyle = self.replacingOccurrences(of: " ", with: "")
        
        // Break the inline into components and set as values in the dictionary
        for subStyle in inlineStyle.split(separator: ";") {
            let components = subStyle.split(separator: ":")
            if components.count != 2 { continue }
            dict[String(components[0])] = String(components[1])
        }
        
        return dict
    }
    
    // Parses the tag and attributes from the inner part of an HTML tag
    // It returns the text, tag, and attributes in the callback.  For example
    //
    //     "This is <span class="label">some</span> text"
    //
    // will trigger the callback 3 times
    //
    //     -> callback("This is ", nil, [:])
    //     -> callback("some", "span", ["class" : "label"])
    //     -> callback(" text", nil, [:])
    //
    func extractTags(callback: (String?, String?, Dictionary<String, String>)->()) {
        // Pointers
        var lastText: String? = nil
        var lastTag: String? = nil
        var lastAttributes = Dictionary<String, String>()
        
        func sendAttributes(_ callback: (String?, String?, Dictionary<String, String>)->()) {
            callback(lastText, lastTag, lastAttributes)
            lastText = nil
            lastTag = nil
            lastAttributes.removeAll()
        }
        
        // State Machine (note this does not support nested tags)
        enum State {
            case text
            case inside_start_tag
            case tagged_text
            case inside_end_tag
        }
        var state: State = .text
        
        // Iteration logic
        var currentIndex = self.startIndex
        
        // Iterate through the string looking for start and end tags
        while currentIndex != self.endIndex {
            
            // State machine is as follows
            // .text -> .inside_start_tag -> .tagged_text -> .inside_end_tag -> .text
            // "This is <span clase="label"> inside the tags </span> of a string"
            let nextTag: String
            if state == .text { nextTag = "<" }
            else if state == .inside_start_tag { nextTag = ">" }
            else if state == .tagged_text { nextTag = "</" }
            else if state == .inside_end_tag { nextTag = ">" }
            else { nextTag = "" } // Not possible to get here
            
            // Get the next matching location
            var noMatch = false
            var nextMatch = self.range(of: nextTag, options: .literal, range: currentIndex..<self.endIndex)?.lowerBound
            if nextMatch == nil {
                noMatch = true
                nextMatch = self.endIndex
            }
            
            if state == .text {
                
                // See if there are values to return
                if (nextMatch! > currentIndex) {
                    lastText = String(self[currentIndex..<nextMatch!])
                    sendAttributes(callback)
                }
                
                // Go to the next state.  Found the first "<" tag (or end of string)
                state = .inside_start_tag
            }
            else if state == .inside_start_tag {
                if noMatch {
                    // TODO: ERROR - Start "<" with no end ">"
                    return
                }
                
                // Parse out the tag and attributes from the string
                var text = String(self[currentIndex..<nextMatch!])
                
                // Check for end tag
                var hasEnded = false
                if text.hasSuffix("/") {
                    hasEnded = true
                    text = String(text.dropLast())
                }
                
                // Extract the tag and the attributes out of the string
                text.extractAttributes(tagCallback: { (tag: String) in
                    lastTag = tag
                }, attributeCallback: { (attribute: String, value: String) in
                    lastAttributes[attribute] = value
                })
                
                // If we have ended, we have a tag with no text.  Return the info and go back to the .text state
                if hasEnded {
                    sendAttributes(callback)
                    state = .text
                }
                else {
                    state = .tagged_text
                }
            }
            else if state == .tagged_text {
                if noMatch {
                    // TODO: ERROR - No end tag found
                    return
                }
                
                // Get the text so it can be returned when the end tag is sensed
                lastText = String(self[currentIndex..<nextMatch!])
                state = .inside_end_tag
            }
            else if state == .inside_end_tag {
                if noMatch {
                    // TODO: ERROR - Start "<" with no end ">"
                    return
                }
                
                let tagEnd = String(self[currentIndex..<nextMatch!]).replacingOccurrences(of: " ", with: "")
                if tagEnd != lastTag {
                    // TODO: ERROR - Somehow the end tag changed.  What happened?
                    return
                }
                
                // Return the data and reset to the text state
                sendAttributes(callback)
                state = .text
            }
            
            // Set the current Index to the character after the found string
            if nextMatch! < self.endIndex {
                currentIndex = self.index(nextMatch!, offsetBy: nextTag.count)
            }
            else {
                currentIndex = self.endIndex
            }
            
        }
    }
    
    // This method will extract the tag and the attributes from inside of an HTML tag.  It
    // does this by using the callbacks.  For example
    //
    //     a href="some url"
    //
    // will do the following
    //
    //     -> tagCallback("a")
    //     -> attributeCallback("href", "some url")
    //
    func extractAttributes(tagCallback: (String)->(), attributeCallback: (String, String)->()) {
        
        // If the tag begins with a space, trim the spaces
        if self.hasPrefix(" ") {
            let trimmedSelf = String(self.trimmingCharacters(in: .whitespaces))
            trimmedSelf.extractAttributes(tagCallback: tagCallback, attributeCallback: attributeCallback)
            return
        }
        
        // Start at the beginning
        var currentIndex = self.startIndex
        
        // Search for a spcae wich signal the start tag
        let tagEnd = self.range(of: " ", options: .literal, range: currentIndex..<self.endIndex)?.lowerBound
        
        // If no next match, then the tag is by itself
        currentIndex = tagEnd != nil ? self.index(tagEnd!, offsetBy: 1) : self.endIndex
        
        // Return the tag
        let tag = String(self[self.startIndex..<currentIndex]).replacingOccurrences(of: " ", with: "")
        tagCallback(tag)
        
        // If we are not at the end, iterate through the attributes looking for the pattern 'name="value" '
        while currentIndex < self.endIndex {
            let equalStart = self.range(of: "=", options: .literal, range: currentIndex..<self.endIndex)?.lowerBound
            if equalStart == nil {
                // TODO: ERROR - no equal found
                return
            }
            
            let name = String(self[currentIndex..<equalStart!]).replacingOccurrences(of: " ", with: "")
            currentIndex = self.index(equalStart!, offsetBy: 1)
            
            let startQuote = self.range(of: "\"", options: .literal, range: currentIndex..<self.endIndex)?.lowerBound
            if startQuote == nil {
                // TODO: ERROR - no start " found
                return
            }
            currentIndex = self.index(startQuote!, offsetBy: 1)
            
            let endQuote = self.range(of: "\"", options: .literal, range: currentIndex..<self.endIndex)?.lowerBound
            if endQuote == nil {
                // TODO: ERROR - no end " found
                return
            }
            
            let attribute = String(self[currentIndex..<endQuote!])
            currentIndex = self.index(endQuote!, offsetBy: 1)
            
            attributeCallback(name, attribute)
        }
    }
}
