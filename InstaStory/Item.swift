//
//  Item.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
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
