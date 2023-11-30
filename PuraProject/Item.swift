//
//  Item.swift
//  PuraProject
//
//  Created by Jake Gray on 11/29/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
