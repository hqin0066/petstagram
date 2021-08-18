//
//  UserRoutes.swift
//  UserRoutes
//
//  Created by Hao Qin on 8/17/21.
//

import Foundation
import Kitura

func initializeUserRoutes(app: App) {
  app.router.get("/api/v1/user", handler: getUser)
  app.router.post("/api/v1/user", handler: addUser)
}

func addUser(user: UserAuthentication, completion: @escaping (UserAuthentication?, RequestError?) -> Void) {
  user.save { savedUser, error in
    var user = savedUser
    user?.password = ""
    completion(user, error)
  }
}

func getUser(query: UserParams, completion: @escaping (UserAuthentication?, RequestError?) -> Void) {
  UserAuthentication.findAll(matching: query) { users, error in
    guard let user = users?.first else {
      completion(nil, error ?? .unauthorized)
      return
    }
    completion(user, nil)
  }
}
