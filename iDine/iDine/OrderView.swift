//
//  OrderView.swift
//  iDine
//
//  Created by 44gimm on 2020/08/24.
//  Copyright © 2020 44gimm. All rights reserved.
//

import SwiftUI

struct OrderView: View {
  
  @EnvironmentObject var order: Order
  
  var body: some View {
    NavigationView {
      List {
        Section {
          ForEach(order.items) { item in
            HStack {
              Text(item.name)
              Spacer()
              Text("$\(item.price)")
            }
          }
        }
        
        Section {
          NavigationLink(destination: CheckoutView()) {
            Text("Price Order")
          }
        }
      }
      .navigationBarTitle("Order")
      .listStyle(GroupedListStyle())
    }
  }
}

struct OrderView_Previews: PreviewProvider {
  
  static let order = Order()
  
  static var previews: some View {
    OrderView()
      .environmentObject(order)
  }
}
