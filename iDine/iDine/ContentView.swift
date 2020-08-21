//
//  ContentView.swift
//  iDine
//
//  Created by 44gimm on 2020/08/21.
//  Copyright © 2020 44gimm. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
  
  var body: some View {
    NavigationView {
      List {
        ForEach(menu) { section in
          Section(header: Text(section.name)) {
            ForEach(section.items) { item in
              Text(item.name)
            }
          }
        }
      }
      .navigationBarTitle("Menu")
      .listStyle(GroupedListStyle())
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
