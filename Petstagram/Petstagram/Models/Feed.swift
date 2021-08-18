//
//  Feed.swift
//  Feed
//
//  Created by Hao Qin on 8/16/21.
//

import Foundation
import Combine

class Feed: ObservableObject {
  @Published var posts: [Post] = []
  @Published var loadError: Error?
  var signInSubscriber: AnyCancellable?
  var getPostSubscriber: AnyCancellable?
  
  init() {
    signInSubscriber = NotificationCenter.default.publisher(for: .signInNotification)
      .sink { [weak self] _ in
        self?.loadFeed()
      }
  }
  
  private func loadFeed() {
    let client = APIClient()
    let request = PostRequest()
    
    getPostSubscriber = client.publisherForRequest(request)
      .sink { result in
        if case .failure(let error) = result {
          self.loadError = error
        }
      } receiveValue: { newPosts in
        self.posts = newPosts
      }
  }
}
