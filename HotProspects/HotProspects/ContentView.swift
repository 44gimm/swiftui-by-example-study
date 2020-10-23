//
//  ContentView.swift
//  HotProspects
//
//  Created by 44gimm on 2020/10/22.
//

import UserNotifications
import SwiftUI

struct ContentView: View {
  
  @State private var backgroundColor = Color.red
  var prospects = Prospects()
  
  var body: some View {
    TabView {
      ProspectsView(filter: .none)
        .tabItem {
          Image(systemName: "person.3")
          Text("Everyone")
        }
      
      ProspectsView(filter: .contacted)
        .tabItem {
          Image(systemName: "checkmark.circle")
          Text("Contacted")
        }
      
      ProspectsView(filter: .uncontacted)
        .tabItem {
          Image(systemName: "questionmark.diamond")
          Text("uncontacted")
        }
      
      MeView()
        .tabItem {
          Image(systemName: "person.crop.square")
          Text("Me")
        }
    }
    .environmentObject(prospects)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
