//
//  ReceiptCreator.swift
//  Meloan
//
//  Created by シン・ジャスティン on 2023/09/16.
//

import Komponents
import SwiftData
import SwiftUI

struct ReceiptCreator: View {

    @Environment(\.dismiss) var dismiss
    @Query private var people: [Person]

    @State var name: String = ""
    @State var personWhoPaid: Person?

    @State var receiptItemsEditable: [ReceiptItemEditable] = []
    @State var discountItemsEditable: [ReceiptItemEditable] = []
    @State var taxItemsEditable: [ReceiptItemEditable] = []
    @State var onCreate: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Receipt.Name", text: $name)
                }
                Section {
                    Picker(selection: $personWhoPaid) {
                        Text("Shared.NoSelection")
                            .tag(nil as Person?)
                        ForEach(people) { person in
                            PersonRow(person: person)
                                .tag(person as Person?)
                        }
                    } label: {
                        Text("Receipt.PaidBy")
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    ListSectionHeader(text: "Receipt.PaidBy")
                } footer: {
                    Text("Receipt.PaidBy.Description")
                }
                Section {
                    ForEach($receiptItemsEditable) { $itemEditable in
                        ReceiptItemEditableRow(name: $itemEditable.name, price: $itemEditable.price,
                                               placeholderText: "Receipt.ProductName")
                    }
                    .onDelete { indexSet in
                        receiptItemsEditable.remove(atOffsets: indexSet)
                    }
                } header: {
                    HStack(alignment: .center, spacing: 4.0) {
                        ListSectionHeader(text: "Receipt.PurchasedItems")
                        Spacer()
                        Button {
                            receiptItemsEditable.insert(ReceiptItemEditable(), at: 0)
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                Section {
                    ForEach($discountItemsEditable) { $itemEditable in
                        ReceiptItemEditableRow(name: $itemEditable.name, price: $itemEditable.price,
                                               placeholderText: "Receipt.ItemName")
                    }
                    .onDelete { indexSet in
                        receiptItemsEditable.remove(atOffsets: indexSet)
                    }
                } header: {
                    HStack(alignment: .center, spacing: 4.0) {
                        ListSectionHeader(text: "Receipt.Discounts")
                        Spacer()
                        Button {
                            discountItemsEditable.insert(ReceiptItemEditable(), at: 0)
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                Section {
                    ForEach($taxItemsEditable) { $itemEditable in
                        ReceiptItemEditableRow(name: $itemEditable.name, price: $itemEditable.price,
                                               placeholderText: "Receipt.ItemName")
                    }
                    .onDelete { indexSet in
                        receiptItemsEditable.remove(atOffsets: indexSet)
                    }
                } header: {
                    HStack(alignment: .center, spacing: 4.0) {
                        ListSectionHeader(text: "Receipt.Tax")
                        Spacer()
                        Button {
                            taxItemsEditable.insert(ReceiptItemEditable(), at: 0)
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Shared.Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ReceiptAssignor(name: $name,
                                        personWhoPaid: $personWhoPaid,
                                        receiptItemsEditable: receiptItemsEditable,
                                        discountItemsEditable: discountItemsEditable,
                                        taxItemsEditable: taxItemsEditable,
                                        onCreate: onCreate)
                    } label: {
                        HStack(alignment: .center, spacing: 2.0) {
                            Text("Shared.Next")
                            Image(systemName: "chevron.right")
                                .font(.system(size: 18.0, weight: .medium))
                        }
                    }
                    .disabled(name == "" || personWhoPaid == nil)
                }
            }
            .navigationTitle("Receipt.Create.Title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}