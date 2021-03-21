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
  @State private var animationAmount: CGFloat = 1
  @State private var enabled = false
  @State private var dragAmount = CGSize.zero
  @State private var isShowingRed = false
  
  let letters = Array("Hello SwiftUI")
  
  var body: some View {
    Button("Tap Me") {
//      self.animationAmount += 1
    }
    .padding(50)
    .background(Color.red)
    .foregroundColor(.white)
    .clipShape(Circle())
    .overlay(
      Circle()
        .stroke(Color.red)
        .scaleEffect(animationAmount)
        .opacity(Double(2 - animationAmount))
        .animation(
          Animation.easeOut(duration: 1)
            .repeatForever(autoreverses: false)
        )
    )
    .onAppear {
      self.animationAmount = 2
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
