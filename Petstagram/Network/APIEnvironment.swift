//
//  APIEnvironment.swift
//  APIEnvironment
//
//  Created by Hao Qin on 8/15/21.
//

import Foundation

struct APIEnvironment {
  var baseUrl: URL
}

extension APIEnvironment {
  static let prod = APIEnvironment(baseUrl: URL(string: "https://example.com/api/v1")!)
  static let local = APIEnvironment(baseUrl: URL(string: "http://localhost:8080/api/v1")!)
  static let local81 = APIEnvironment(baseUrl: URL(string: "http://localhost:8081/api/v1")!)
}
