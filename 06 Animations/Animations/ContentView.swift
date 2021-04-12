//
//  ContentView.swift
//  Animations
//
//  Created by 44gimm on 2020/09/09.
//  Copyright © 2020 44gimm. All rights reserved.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
  let amount: Double
  let anchor: UnitPoint
  
  func body(content: Content) -> some View {
    content.rotationEffect(.degrees(amount), anchor: anchor)
      .clipped()
  }
}

extension AnyTransition {
  static var pivot: AnyTransition {
    .modifier(active: CornerRotateModifier(amount: -90, anchor: .topLeading), identity: CornerRotateModifier(amount: 0, anchor: .topLeading))
  }
}

struct ContentView: View {
  @State private var animationAmount = 0.0
  
  var body: some View {
    Button("Tap Me") {
      withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
        self.animationAmount += 360
      }
    }
    .padding(50)
    .background(Color.red)
    .foregroundColor(.white)
    .clipShape(Circle())
    .rotation3DEffect(.degrees(animationAmount), axis: (x:0, y: 1, z: 0))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
