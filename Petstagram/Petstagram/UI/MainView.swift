//
//  MainView.swift
//  Petstagram
//
//  Created by Hao Qin on 8/15/21.
//

import SwiftUI
import Combine

struct MainView: View {
  
  @State private var showingLogin = true
  @State private var showingPostView = false
  @StateObject private var userData = UserData()
  
  let signInPublisher = NotificationCenter.default
    .publisher(for: .signInNotification)
    .receive(on: RunLoop.main)
  let signOutPublisher = NotificationCenter.default
    .publisher(for: .signOutNotification)
    .receive(on: RunLoop.main)
  
  var body: some View {
    TabView(selection: $userData.selectedTab) {
      FeedView()
        .tabItem {
          Image("home")
          Text("Home")
        }
        .tag(0)
      
      Text("")
        .sheet(isPresented: $showingPostView) {
          CreatePostView()
            .environmentObject(userData)
        }
        .tabItem {
          Image("photo")
          Text("Post")
        }
        .tag(1)
      
      Text("Tab Content 3")
        .tabItem {
          Image("profile")
          Text("Profile")
        }
        .tag(2)
    }
    .accentColor(.accentGreen)
    .fullScreenCover(isPresented: $showingLogin) {
      LoginSignupView()
    }
    .onReceive(signInPublisher) { _ in
      showingLogin = false
    }
    .onReceive(signOutPublisher) { _ in
      showingLogin = true
    }
    .onReceive(userData.$selectedTab) { _ in
      showingPostView = (userData.selectedTab == 1)
    }
  }
}

struct MainviewView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
