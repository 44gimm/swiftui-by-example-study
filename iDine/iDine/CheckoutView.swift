//
//  CehckoutView.swift
//  iDine
//
//  Created by 44gimm on 2020/08/24.
//  Copyright © 2020 44gimm. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
  
  @EnvironmentObject var order: Order
  
  static let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
  static let tipAmounts = [10, 15, 20, 25, 0]
  
  @State private var paymentType = 0
  @State private var addLoyaltyDetails = false
  @State private var loyaltyNumber = ""
  @State private var tipAmount = 1
  @State private var showingPaymentAlert = false
  
  var totalPrice: Double {
    let total = Double(order.total)
    let tipValue = total / 100 * Double(Self.tipAmounts[tipAmount])
    return total + tipValue
  }
  
  var body: some View {
    Form {
      Section {
        Picker("How do you want to pay?", selection: $paymentType) {
          ForEach(0 ..< Self.paymentTypes.count) {
            Text(Self.paymentTypes[$0])
          }
        }
        
        Toggle(isOn: $addLoyaltyDetails.animation()) {
          Text("Add iDine loyalty card")
        }
        
        if addLoyaltyDetails {
          TextField("Enter yout iDine ID", text: $loyaltyNumber)
        }
      }
      
      Section(header: Text("add a tip?")) {
        Picker("Percentage: ", selection: $tipAmount) {
          ForEach(0 ..< Self.tipAmounts.count) {
            Text("\(Self.tipAmounts[$0])%")
          }
        }.pickerStyle(SegmentedPickerStyle())
      }
      
      Section(header: Text("Total: \(totalPrice, specifier: "%.2f")").font(.largeTitle)) {
        Button("Confirm order") {
          self.showingPaymentAlert.toggle()
        }
      }
    }
    .navigationBarTitle(Text("Payment"), displayMode: .inline)
    .alert(isPresented: $showingPaymentAlert) { () -> Alert in
      Alert(
        title: Text("Order confirmed"),
        message: Text("Your total was $\(totalPrice, specifier: "%.2f") - thank you!"),
        dismissButton: .default(Text("OK"))
      )
    }
  }
}

struct CehckoutView_Previews: PreviewProvider {
  static let order = Order()
  static var previews: some View {
    CheckoutView()
      .environmentObject(order)
  }
}
