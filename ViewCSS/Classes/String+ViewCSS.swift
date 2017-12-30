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
                    newString += "_" + temp.lowercased() + str
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
    
    func valueOfHex(start: Int, length: Int) -> CGFloat {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: (start+length))
        let hexString = String(self[startIndex..<endIndex])
        return hexString.hexToFloat
    }
    
    var hexToFloat: CGFloat {
        if let hexInt = UInt(self, radix: 16) {
            return CGFloat(hexInt)
        }
        else {
            return CGFloat(0)
        }
    }
    
    var percentageToFloat: CGFloat {
        let converted = self.hasSuffix("%") ? String(self.dropLast(1)) : self
        if let percentInt = UInt(converted) {
            return CGFloat(percentInt)/100.0
        }
        else {
            return CGFloat(0)
        }
    }
}
