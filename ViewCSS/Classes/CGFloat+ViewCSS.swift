//
//  CGFloat+ViewCSS.swift
//  FBSnapshotTestCase
//
//  Created by Eric Chapman on 12/31/17.
//

import Foundation

extension CGFloat {
    var toPX : String {
        return String(format: "%dpx", Int(self.rounded()))
    }
}
