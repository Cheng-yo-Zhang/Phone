//
//  Item.swift
//  Phone
//
//  Created by Louis Chang on 2024/12/11.
//

import Foundation
import SwiftData

@Model
final class Contact {
    var name: String
    var phoneNumber: String
    var email: String
    var notes: String
    var createdDate: Date
    
    init(name: String, phoneNumber: String, email: String, notes: String, createdDate: Date = Date()) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.notes = notes
        self.email = email
        self.createdDate = createdDate
    }
}
