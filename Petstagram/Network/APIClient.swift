//
//  APIClient.swift
//  APIClient
//
//  Created by Hao Qin on 8/15/21.
//

import Foundation
import Combine

enum APIError: Error {
  case requestFailed(Int)
  case postProcessingFailed(Error?)
}

struct APIClient {
  let session: URLSession
  let environment: APIEnvironment
  
  init(session: URLSession = .shared, environment: APIEnvironment = .prod) {
    self.session = session
    self.environment = environment
  }
  
  func publisherForRequest<T: APIRequest>(_ request: T) -> AnyPublisher<T.Response, Error> {
    let url = environment.baseURL.appendingPathComponent(request.path)
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.httpBody = request.body
    
    let publisher = session.dataTaskPublisher(for: urlRequest)
      .tryMap { data, response -> Data in
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
          let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
          throw APIError.requestFailed(statusCode)
        }
        return data
      }
      .tryMap { data -> T.Response in
        try request.handle(response: data)
      }
      .tryCatch { error -> AnyPublisher<T.Response, APIError> in
        throw APIError.postProcessingFailed(error)
      }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
    
    return publisher
  }
}
