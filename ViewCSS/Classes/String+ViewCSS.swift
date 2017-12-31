//
//  String+ViewCSS.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/29/17.
//

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
                if temp.count > 1 {
                    if newString.count > 0 { newString += "_" }
                    newString += temp.dropLast().lowercased() + "_" + temp.dropFirst(temp.count-1).lowercased() + str
                    temp = ""
                }
                else if temp.count == 1 {
                    if newString.count > 0 {
                        newString += "_"
                    }
                    newString += temp.lowercased() + str
                    temp = ""
                }
                else {
                    newString += str
                }
            }
        }
        
        if temp.count > 0 {
            newString += "_" + temp.lowercased()
            temp = ""
        }
        
        return newString
    }
    
    func valueOfHex(start: Int, length: Int) -> CGFloat? {
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
