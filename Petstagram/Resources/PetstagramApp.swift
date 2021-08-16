//
//  PetstagramApp.swift
//  Petstagram
//
//  Created by Hao Qin on 8/15/21.
//

import SwiftUI
import Swifter

@main
struct PetstagramApp: App {
  
  let server: HttpServer = {
    let server = HttpServer()
    
    try? server.start(8081)
    server.GET["/api/v1/posts"] = { _ in HttpResponse.ok(.text(JsonData.goodFeed)) }
    server.POST["api/v1/user"] = { _ in HttpResponse.ok(.text(JsonData.goodSignUp)) }
    
    return server
  }()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
