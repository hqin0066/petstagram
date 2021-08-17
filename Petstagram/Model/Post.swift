//
//  Post.swift
//  Post
//
//  Created by Hao Qin on 8/15/21.
//

import Foundation

struct Post: Codable, Identifiable {
  var id: UUID?
  var caption: String
  var createdAt: Date
  var createdByUser: String
  
  init(id: UUID? = nil, caption: String, createdAt: Date = Date(), createdByUser: String = currentUser?.id ?? "") {
    self.id = id
    self.caption = caption
    self.createdAt = createdAt
    self.createdByUser = createdByUser
  }
}
