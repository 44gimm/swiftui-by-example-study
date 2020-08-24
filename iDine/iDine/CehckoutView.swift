//
//  CehckoutView.swift
//  iDine
//
//  Created by 44gimm on 2020/08/24.
//  Copyright © 2020 44gimm. All rights reserved.
//

import SwiftUI

struct CehckoutView: View {
  
  @EnvironmentObject var order: Order
  static let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
  @State private var paymentType = 0
  
  var body: some View {
    VStack {
      Section {
        Picker("How do you want to pay?", selection: $paymentType) {
          ForEach(0 ..< Self.paymentTypes.count) {
            Text(Self.paymentTypes[$0])
          }
        }
      }
    }
    .navigationBarTitle(Text("Payment"), displayMode: .inline)
  }
}

struct CehckoutView_Previews: PreviewProvider {
  static let order = Order()
  static var previews: some View {
    CehckoutView()
      .environmentObject(order)
  }
}
