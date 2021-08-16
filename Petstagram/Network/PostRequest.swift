//
//  PostRequest.swift
//  PostRequest
//
//  Created by Hao Qin on 8/15/21.
//

import Foundation

struct PostRequest: APIRequest {
  typealias Response = [Post]
  
  var method: HTTPMethod { return .GET }
  var path: String { return "/posts" }
  var body: Data? { return nil }
  
  func handle(response: Data) throws -> [Post] {
    return try JSONDecoder().decode(Response.self, from: response)
  }
}
