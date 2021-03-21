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
    print(animationAmount)
    
    return VStack {
      Stepper(
        "Scale amount",
        value: $animationAmount.animation(
          Animation.easeInOut(duration: 1)
            .repeatCount(3, autoreverses: true)
        ),
        in: 1...10)

      Spacer()

      Button("Tap Me") {
        self.animationAmount += 1
      }
      .padding(40)
      .background(Color.red)
      .foregroundColor(.white)
      .clipShape(Circle())
      .scaleEffect(animationAmount)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}