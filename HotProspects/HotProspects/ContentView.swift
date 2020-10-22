//
//  ContentView.swift
//  HotProspects
//
//  Created by 44gimm on 2020/10/22.
//

import UserNotifications
import SwiftUI

enum NetworkError: Error {
  case badURL, requestFailed, unknown
}

struct ContentView: View {
  
  @State private var backgroundColor = Color.red
  var prospects = Prospects()
  
  var body: some View {
//    VStack {
//      Text("Hello world")
//        .padding()
//        .background(backgroundColor)
//
//      Text("Change Color")
//        .padding()
//        .contextMenu {
//          Button(action: {
//            self.backgroundColor = .red
//          }) {
//            Text("Red")
//            Image(systemName: "checkmark.circle.fill")
//              .foregroundColor(.red)
//          }
//
//          Button(action: {
//            self.backgroundColor = .green
//          }) {
//            Text("Green")
//          }
//
//          Button(action: {
//            self.backgroundColor = .blue
//          }) {
//            Text("Blue")
//          }
//        }
//    }
    
//    VStack {
//      Button("Request permission") {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
//          if success {
//            print("All set")
//          } else if let error = error {
//            print(error.localizedDescription)
//          }
//        }
//      }
//
//      Button("Scehdule Notification") {
//        let content = UNMutableNotificationContent()
//        content.title = "Feed the cat"
//        content.subtitle = "It looks hungry"
//        content.sound = UNNotificationSound.default
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request)
//      }
//    }
    
    
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
  
  func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
    guard let url = URL(string: urlString) else {
      completion(.failure(.badURL))
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      DispatchQueue.main.async {
        if let data = data {
          let stringData = String(decoding: data, as: UTF8.self)
          completion(.success(stringData))
        } else if error != nil {
          completion(.failure(.requestFailed))
        } else {
          completion(.failure(.unknown))
        }
      }
    }.resume()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
