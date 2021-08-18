//
//  UserRequests.swift
//  UserRequests
//
//  Created by Hao Qin on 8/15/21.
//

import Foundation
import KituraContracts

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
  var contentType: String { return "application/json" }
  var additionalHeaders: [String : String] { return [:] }
  var body: Data? { return nil }
  var params: UserParams? {
    return UserParams(id: user.id, password: user.password ?? "")
  }
  
  func handle(response: Data) throws -> Void {
    currentUser = user
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
  var contentType: String { return "application/json" }
  var additionalHeaders: [String : String] { return [:] }
  var body: Data? {
    return try? JSONEncoder().encode(user)
  }
  var params: EmptyParams? { return nil }
  
  func handle(response: Data) throws -> Void {
    currentUser = user
    NotificationCenter.default.post(name: .signInNotification, object: nil)
  }
}
