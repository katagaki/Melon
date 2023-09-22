//
//  ReceiptDetailView.swift
//  Meloan
//
//  Created by シン・ジャスティン on 2023/09/17.
//

import ConfettiSwiftUI
import Komponents
import SwiftUI

struct ReceiptDetailView: View {

    @State var receipt: Receipt
    @State var confettiCounter: Int = 0

    var body: some View {
        List {
            Section {
                ForEach(receipt.participants(sortPayerOnTop: true)) { person in
                    PersonRow(person: person, isPersonWhoPaid: person.id == receipt.personWhoPaid?.id ?? "")
                }
            } header: {
                ListSectionHeader(text: "Receipt.Participants")
                    .font(.body)
            }
            if !receipt.items().isEmpty {
                Section {
                    ForEach(receipt.items()) { item in
                        Button {
                            item.paid.toggle()
                            MeloanApp.reloadWidget()
                            if receipt.isPaid() {
                                confettiCounter += 1
                            }
                        } label: {
                            HStack(alignment: .center, spacing: 16.0) {
                                Group {
                                    if let person = item.person {
                                        if let data = person.photo, let image = UIImage(data: data) {
                                            Image(uiImage: image)
                                                .resizable()
                                        } else {
                                            Image("Profile.Generic")
                                                .resizable()
                                        }
                                    } else {
                                        Image("Profile.Shared")
                                            .resizable()
                                    }
                                }
                                .frame(width: 32.0, height: 32.0)
                                .clipShape(Circle())
                                ReceiptItemRow(name: item.name, price: item.price)
                                    .strikethrough(item.paid)
                            }
                        }
                    }
                } header: {
                    ListSectionHeader(text: "Receipt.PurchasedItems")
                        .font(.body)
                        .popoverTip(ReceiptMarkPaidTip())
                } footer: {
                    HStack(alignment: .center, spacing: 4.0) {
                        Text("Receipt.Total")
                        Spacer()
                        Text("\(receipt.sumOfItems(), specifier: "%.2f")")
                            .font(.system(size: 14.0))
                            .monospaced()
                    }
                    .font(.body)
                    .bold()
                    .foregroundStyle(.primary)
                }
            }
            if !receipt.discountItems().isEmpty {
                Section {
                    ForEach(receipt.discountItems()) { item in
                        ReceiptItemRow(name: item.name, price: item.price)
                    }
                } header: {
                    ListSectionHeader(text: "Receipt.Discounts")
                        .font(.body)
                }
            }
            if !receipt.taxItems().isEmpty {
                Section {
                    ForEach(receipt.taxItems()) { item in
                        ReceiptItemRow(name: item.name, price: item.price)
                    }
                } header: {
                    ListSectionHeader(text: "Receipt.Tax")
                        .font(.body)
                } footer: {
                    HStack(alignment: .center, spacing: 4.0) {
                        Text("Receipt.Tax.Detail")
                        Spacer()
                        Text("\(Int(receipt.taxRate() * 100), specifier: "%d")%")
                            .font(.system(size: 14.0))
                            .monospaced()
                    }
                    .font(.body)
                    .bold()
                    .foregroundStyle(.primary)
                }
            }
        }
        .confettiCannon(counter: $confettiCounter, num: Int(receipt.sum()), rainHeight: 1000.0, radius: 500.0)
        .navigationTitle(receipt.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
