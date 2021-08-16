//
//  ContentView.swift
//  Petstagram
//
//  Created by Hao Qin on 8/15/21.
//

import SwiftUI
import Combine

struct ContentView: View {
  var subscription: AnyCancellable = {
    let client = APIClient()
    let request = PostRequest()
    return client.publisherForRequest(request)
      .sink { result in
        print(result)
      } receiveValue: { newPosts in
        print(newPosts)
      }
  }()
  
  var body: some View {
    Text("Hello, world!")
      .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
