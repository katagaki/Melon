//
//  ReceiptAssignor.swift
//  Meloan
//
//  Created by シン・ジャスティン on 2023/09/16.
//

import SwiftData
import SwiftUI

struct ReceiptAssignor: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var people: [Person]

    @Binding var name: String
    @State var receiptItems: [ReceiptItem] = []
    @State var discountItems: [DiscountItem] = []
    @State var taxItems: [TaxItem] = []
    @Binding var personWhoPaid: Person?

    @State var receiptItemsEditable: [ReceiptItemEditable]
    @State var discountItemsEditable: [ReceiptItemEditable]
    @State var taxItemsEditable: [ReceiptItemEditable]
    @State var onCreate: () -> Void

    var body: some View {
        List {
            ForEach($receiptItemsEditable) { $itemEditable in
                ReceiptItemAssignableRow(name: itemEditable.name, price: itemEditable.price,
                                         personWhoOrdered: $itemEditable.person)
            }
        }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        for receiptItemEditable in receiptItemsEditable {
                            let receiptItem = ReceiptItem(from: receiptItemEditable)
                            receiptItems.append(receiptItem)
                        }
                        if name != "", let personWhoPaid = personWhoPaid {
                            let newReceipt = Receipt(name: name)
                            newReceipt.addReceiptItems(from: receiptItems)
                            newReceipt.addDiscountItems(from: discountItems)
                            newReceipt.addTaxItems(from: taxItems)
                            newReceipt.setPersonWhoPaid(to: personWhoPaid)
                            modelContext.insert(newReceipt)
                        }
                        onCreate()
                    } label: {
                        Text("Shared.Create")
                    }
                }
            }
            .navigationTitle("Receipt.Assign.Title")
            .navigationBarTitleDisplayMode(.inline)
    }
}
