//
//  ContentView.swift
//  VIewsAndModifiers
//
//  Created by 44gimm on 2020/09/04.
//  Copyright © 2020 44gimm. All rights reserved.
//

import SwiftUI

struct CapsuleText: View {
  var text: String
  
  var body: some View {
    Text(text)
      .font(.largeTitle)
      .padding()
//      .foregroundColor(.white)
      .background(Color.blue)
      .clipShape(Capsule())
  }
}

struct Title: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.largeTitle)
      .foregroundColor(.white)
      .padding()
      .background(Color.blue)
      .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

struct Watermark: ViewModifier {
  var text: String
  
  func body(content: Content) -> some View {
    ZStack(alignment: .bottomTrailing) {
      content
      
      Text(text)
        .font(.caption)
        .foregroundColor(.white)
        .padding(5)
        .background(Color.black)
    }
  }
}

extension View {
  func titleStyle() -> some View {
    self.modifier(Title())
  }
  
  func watermarked(with text: String) -> some View {
    self.modifier(Watermark(text: text))
  }
}

struct GridStack<Content: View>: View {
  let rows: Int
  let columns: Int
  let content: (Int, Int) -> Content
  
  var body: some View {
    VStack {
      ForEach(0 ..< rows) { row in
        HStack {
          ForEach(0 ..< self.columns) { column in
            self.content(row, column)
          }
        }
      }
    }
  }
  
  init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
    self.rows = rows
    self.columns = columns
    self.content = content
  }
}

struct ContentView: View {
  
  var motto1: some View { Text("Draco dormie") }
  let motto2 = Text("nunquam titillandus")
  
  var body: some View {
    // Views as Properties
//    VStack {
//      motto1
//        .foregroundColor(.red)
//      motto2
//        .foregroundColor(.blue)
//    }
    
    // View composition
    VStack(spacing: 10) {
      CapsuleText(text: "Hello world")
        .foregroundColor(.yellow)
      CapsuleText(text: "Hello Swift")
        .foregroundColor(.white)
    }
    
    
    //    Text("Hello world")
    //      .titleStyle()
    
    //        Color.blue
    //          .frame(width: 300, height: 300)
    //          .watermarked(with: "Hacking with swift")
    
    //    GridStack(rows: 4, columns: 4) { row, col in
    //      Image(systemName: "\(row * 4 + col).circle")
    //      Text("R\(row) C\(col)")
    //    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
