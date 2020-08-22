//
//  ItemDetail.swift
//  iDine
//
//  Created by 44gimm on 2020/08/22.
//  Copyright © 2020 44gimm. All rights reserved.
//

import SwiftUI

struct ItemDetail: View {
  
  var item: MenuItem
  
  var body: some View {
    VStack {
      ZStack(alignment: .bottomTrailing) {
        Image(item.mainImage)
        Text("Photo: \(item.photoCredit)")
          .padding(4)
          .background(Color.black)
          .font(.caption)
          .foregroundColor(.white)
          .offset(x: -5, y: -5)
      }
      
      Text(item.description)
        .padding()
      
      Spacer()
      
    }.navigationBarTitle(
      Text(item.name),
      displayMode: .inline)
  }
}

struct ItemDetail_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ItemDetail(item: MenuItem.example)
    }
  }
}
