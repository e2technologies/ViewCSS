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
}
