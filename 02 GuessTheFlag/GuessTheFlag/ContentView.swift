//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by 44gimm on 2020/09/03.
//  Copyright © 2020 44gimm. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @State private var contries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
  @State private var correctAnswer = Int.random(in: 0...2)
  @State private var showingScore = false
  @State private var scoreTitle = ""
  @State private var userScore = 0
  @State private var selectedNumber = 0
  
  var body: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
      
      VStack(spacing: 30) {
        VStack {
          Text("Tap the flag of").foregroundColor(.white)
          Text(contries[correctAnswer])
            .foregroundColor(.white)
            .font(.largeTitle)
            .fontWeight(.black)
        }
        
        ForEach(0 ..< 3) { number in
          Button(action: {
            self.flagTapped(number)
            
          }) {
            Image(self.contries[number])
              .renderingMode(.original)
              .clipShape(Capsule())
              .overlay(Capsule().stroke(Color.black, lineWidth: 1))
              .shadow(color: .black, radius: 2)
          }
        }
        
        Text("user score: \(userScore)")
          .foregroundColor(.white)
          .font(.largeTitle)
          .fontWeight(.black)
        
        Spacer()
      }
    }
    .alert(isPresented: $showingScore) { () -> Alert in
      Alert(title: Text(scoreTitle), message: Text("Wrong! That's the flag of \(contries[selectedNumber])"), dismissButton: .default(Text("Continue")) {
        self.askQuestion()
      })
    }
  }
  
  func flagTapped(_ number: Int) {
    if number == correctAnswer {
      scoreTitle = "Correct"
      userScore += 100
      askQuestion()
      
    } else {
      scoreTitle = "Wrong"
      userScore -= 100
      selectedNumber = number
      showingScore = true
    }
  }
  
  func askQuestion() {
    contries = contries.shuffled()
    correctAnswer = Int.random(in: 0...2)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
