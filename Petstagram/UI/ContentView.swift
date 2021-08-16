//
//  ContentView.swift
//  Petstagram
//
//  Created by Hao Qin on 8/15/21.
//

import SwiftUI
import Combine

struct ContentView: View {
  
  @State private var showingLogin = true
  
  let signInPublisher = NotificationCenter.default
    .publisher(for: .signInNotification)
    .receive(on: RunLoop.main)
  let signOutPublisher = NotificationCenter.default
    .publisher(for: .signOutNotification)
    .receive(on: RunLoop.main)
  
  var body: some View {
    Text("Hello, world!")
      .padding()
      .fullScreenCover(isPresented: $showingLogin) {
        LoginSignupView()
      }
      .onReceive(signInPublisher) { _ in
        showingLogin = false
      }
      .onReceive(signOutPublisher) { _ in
        showingLogin = true
      }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
