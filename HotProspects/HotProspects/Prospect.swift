//
//  Prospect.swift
//  HotProspects
//
//  Created by 44gimm on 2020/10/22.
//

import SwiftUI

class Prospect: Identifiable, Codable {
  var id = UUID()
  var name = "Anonymous"
  var emailAddress = ""
  var isContacted = false
}

class Prospects: ObservableObject {
  @Published var people: [Prospect]
  
  init() {
    self.people = []
  }
}
