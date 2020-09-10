//
//  ContentView.swift
//  IExpense
//
//  Created by 44gimm on 2020/09/10.
//  Copyright © 2020 44gimm. All rights reserved.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
  let id = UUID()
  let name: String
  let type: String
  let amount: Int
}

class Expenses: ObservableObject {
  @Published var items = [ExpenseItem]() {
    didSet {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(items) {
        UserDefaults.standard.set(encoded, forKey: "Items")
      }
    }
  }
  
  init() {
    if let items = UserDefaults.standard.data(forKey: "Items") {
      let decoder = JSONDecoder()
      if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
        self.items = decoded
        
        return
      }
    }
    
    self.items = []
  }
}

struct ContentView: View {
  @ObservedObject private var expenses = Expenses()
  @State private var showingAddExpsnse = false
  
  var body: some View {
    NavigationView {
      List {
        ForEach(expenses.items) { item in
          HStack {
            
            VStack(alignment: .leading) {
              Text(item.name)
                .font(.headline)
              Text(item.type)
            }
            
            Spacer()
            Text("$\(item.amount)")
          }
        }
        .onDelete(perform: removeItems(at:))
      }
      .navigationBarTitle("iExpense")
      .navigationBarItems(trailing:
        Button(action: {
          self.showingAddExpsnse = true
        }) {
          Image(systemName: "plus")
        }
      )
      .sheet(isPresented: $showingAddExpsnse) {
        AddView(expenses: self.expenses)
      }
    }
  }
  
  func removeItems(at offsets: IndexSet) {
    expenses.items.remove(atOffsets: offsets)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
