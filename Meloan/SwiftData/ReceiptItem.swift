//
//  ReceiptItem.swift
//  Meloan
//
//  Created by シン・ジャスティン on 2023/09/16.
//

import Foundation
import SwiftData

@Model
final class ReceiptItem {
    var name: String
    var price: Double
    var amount: Int
    var person: Person?

    init(name: String, price: Double, amount: Int, person: Person) {
        self.name = name
        self.price = price
        self.amount = amount
        self.person = person
    }

    init(name: String, price: Double, amount: Int) {
        self.name = name
        self.price = price
        self.amount = amount
    }
}
