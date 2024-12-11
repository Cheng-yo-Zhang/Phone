//
//  Item.swift
//  Phone
//
//  Created by Louis Chang on 2024/12/11.
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
