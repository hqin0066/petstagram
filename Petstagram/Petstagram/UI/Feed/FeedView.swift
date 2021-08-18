//
//  FeedView.swift
//  FeedView
//
//  Created by Hao Qin on 8/16/21.
//

import SwiftUI

struct FeedView: View {
  
  @StateObject var feed = Feed()
  
  var body: some View {
    List(feed.posts) { post in
      FeedCell(post: post)
    }
    .listStyle(PlainListStyle())
  }
}

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    let feed = Feed()
    for index in 1...5 {
      feed.posts.append(Post(id: UUID(), caption: "Caption \(index)", createdAt: Date(), createdByUser: "User: \(index)"))
    }
    return FeedView(feed: feed)
  }
}
