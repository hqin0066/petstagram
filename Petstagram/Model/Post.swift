//
//  Post.swift
//  Post
//
//  Created by Hao Qin on 8/15/21.
//

import Foundation

struct Post: Codable {
  var caption: String
  var createdAt: Date
  var imageURL: URL
}
