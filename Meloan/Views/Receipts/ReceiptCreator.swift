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

    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query(sort: \Person.name) var people: [Person]

    @State var name: String = ""
    @State var personWhoPaid: Person?
    @State var peopleWhoParticipated: [Person] = []

    @State var receiptItemsEditable: [ReceiptItemEditable] = []
    @State var discountItemsEditable: [ReceiptItemEditable] = []
    @State var taxItemsEditable: [ReceiptItemEditable] = []

    @State var receiptItems: [ReceiptItem] = []
    @State var discountItems: [DiscountItem] = []
    @State var taxItems: [TaxItem] = []

    var body: some View {
            List {
                Section {
                    TextField("Receipt.Name", text: $name)
                        .textInputAutocapitalization(.words)
                }
                Section {
                    NavigationLink {
                        PeoplePicker(title: "Receipt.Participants", selection: $peopleWhoParticipated)
                    } label: {
                        HStack {
                            Text("Receipt.Participants")
                                .bold()
                            Spacer()
                            Text(NSLocalizedString("Receipt.Participants.Label", comment: "")
                                .replacingOccurrences(of: "%1", with: String(peopleWhoParticipated.count)))
                            .lineLimit(1)
                            .truncationMode(.head)
                            .foregroundStyle(.secondary)
                        }
                    }
                    Picker(selection: $personWhoPaid) {
                        Text("Shared.NoSelection")
                            .tag(nil as Person?)
                        ForEach(peopleWhoParticipated
                            .sorted(by: { $0.id == "ME" || $0.name < $1.name })) { person in
                            PersonRow(person: person)
                                .tag(person as Person?)
                        }
                    } label: {
                        Text("Receipt.PaidBy")
                            .bold()
                    }
                    .pickerStyle(.navigationLink)
                } footer: {
                    Text("Receipt.Participants.Description")
                        .font(.subheadline)
                }
                Section {
                    ForEach($receiptItemsEditable) { $itemEditable in
                        ReceiptItemAssignableRow(name: $itemEditable.name, price: $itemEditable.price,
                                                 personWhoOrdered: $itemEditable.person,
                                                 peopleWhoParticipated: $peopleWhoParticipated,
                                                 placeholderText: "Receipt.ProductName")
                    }
                    .onDelete { indexSet in
                        receiptItemsEditable.remove(atOffsets: indexSet)
                    }
                } header: {
                    HStack(alignment: .center, spacing: 4.0) {
                        ListSectionHeader(text: "Receipt.PurchasedItems")
                            .font(.body)
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
                        discountItemsEditable.remove(atOffsets: indexSet)
                    }
                } header: {
                    HStack(alignment: .center, spacing: 4.0) {
                        ListSectionHeader(text: "Receipt.Discounts")
                            .font(.body)
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
                        taxItemsEditable.remove(atOffsets: indexSet)
                    }
                } header: {
                    HStack(alignment: .center, spacing: 4.0) {
                        ListSectionHeader(text: "Receipt.Tax")
                            .font(.body)
                        Spacer()
                        Button {
                            taxItemsEditable.insert(ReceiptItemEditable(), at: 0)
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(alignment: .center, spacing: 0.0) {
                    Button {
                        for receiptItemEditable in receiptItemsEditable {
                            let receiptItem = ReceiptItem(from: receiptItemEditable)
                            receiptItem.setPurchaser(to: receiptItemEditable.person)
                            receiptItems.append(receiptItem)
                        }
                        for discountItemEditable in discountItemsEditable {
                            let receiptItem = DiscountItem(from: discountItemEditable)
                            discountItems.append(receiptItem)
                        }
                        for taxItemEditable in taxItemsEditable {
                            let receiptItem = TaxItem(from: taxItemEditable)
                            taxItems.append(receiptItem)
                        }
                        if name != "" {
                            let newReceipt = Receipt(name: name)
                            newReceipt.addReceiptItems(from: receiptItems)
                            newReceipt.addDiscountItems(from: discountItems)
                            newReceipt.addTaxItems(from: taxItems)
                            newReceipt.setPersonWhoPaid(to: personWhoPaid)
                            newReceipt.addPeopleWhoParticipated(from: peopleWhoParticipated)
                            modelContext.insert(newReceipt)
                            try? modelContext.save()
                        }
                        dismiss()
                    } label: {
                        LargeButtonLabel(iconName: "plus.circle.fill", text: "Shared.Create")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(name == "" || personWhoPaid == nil || receiptItemsEditable.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .clipShape(RoundedRectangle(cornerRadius: 99))
                    .frame(minHeight: 56.0)
                    .padding([.leading, .trailing, .bottom], 16.0)
                }
            }
            .navigationTitle("Receipt.Create.Title")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: peopleWhoParticipated) { _, _ in
                if let personWhoPaid = personWhoPaid {
                    if !peopleWhoParticipated.contains(where: { $0.id == personWhoPaid.id }) {
                        self.personWhoPaid = nil
                    }
                }
            }
    }
}
