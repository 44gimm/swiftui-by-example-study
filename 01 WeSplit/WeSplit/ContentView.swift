//
//  ContentView.swift
//  WeSplit
//
//  Created by 44gimm on 2021/01/28.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      Form {
        Section {
          Text("Hello World")
        }
      }
      .navigationBarTitle(Text("SwiftUI"), displayMode: .inline)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
