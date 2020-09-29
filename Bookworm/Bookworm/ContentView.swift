//
//  ContentView.swift
//  Bookworm
//
//  Created by 44gimm on 2020/09/29.
//  Copyright © 2020 44gimm. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.managedObjectContext) var moc
  @FetchRequest(entity: Book.entity(), sortDescriptors: []) var books: FetchedResults<Book>
  
  @State private var showingAddScreen = false

  var body: some View {
    NavigationView {
      Text("Count: \(books.count)")
      .navigationBarTitle("Bookwork")
      .navigationBarItems(trailing:
        Button(action: {
          self.showingAddScreen.toggle()
        }, label: {
          Image(systemName: "plus")
        })
        
      ).sheet(isPresented: $showingAddScreen) {
        AddBookView().environment(\.managedObjectContext, self.moc)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
