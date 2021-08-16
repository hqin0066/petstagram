//
//  UserRequests.swift
//  UserRequests
//
//  Created by Hao Qin on 8/15/21.
//

import Foundation

extension Notification.Name {
  static let signInNotification = Notification.Name("SignInNotification")
  static let signOutNotification = Notification.Name("SignOutNotification")
}

struct SignInUserRequest: APIRequest {
  let user: UserAuthentication
  
  init(username: String, password: String) {
    self.user = UserAuthentication(id: username, password: password)
  }
  
  typealias Response = Void
  
  var method: HTTPMethod { return .GET }
  var path: String { return "/user" }
  var body: Data? { return nil }
  
  func handle(response: Data) throws -> Void {
    NotificationCenter.default.post(name: .signInNotification, object: nil)
  }
}

struct SignUpUserRequest: APIRequest {
  let user: UserAuthentication
  
  init(username: String, email: String, password: String) {
    self.user = UserAuthentication(id: username, email: email, password: password)
  }
  
  typealias Response = Void
  
  var method: HTTPMethod { return .POST }
  var path: String { return "/user" }
  var body: Data? {
    return try? JSONEncoder().encode(user)
  }
  
  func handle(response: Data) throws -> Void {
    NotificationCenter.default.post(name: .signInNotification, object: nil)
  }
}
