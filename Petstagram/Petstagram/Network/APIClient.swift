//
//  APIClient.swift
//  APIClient
//
//  Created by Hao Qin on 8/15/21.
//

import Foundation
import Combine
import KituraContracts

enum APIError: Error {
  case urlProcessingFailed
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
    var url = environment.baseUrl.appendingPathComponent(request.path)
    var urlRequest: URLRequest
    if let params = request.params {
      let failureResult: Fail<T.Response, Error> = Fail(error: APIError.urlProcessingFailed)
      guard let queryItems: [URLQueryItem] = try? QueryEncoder().encode(params),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
              return failureResult.eraseToAnyPublisher()
            }
      
      components.queryItems = queryItems
      guard let newUrl = components.url else {
        return failureResult.eraseToAnyPublisher()
      }
      url = newUrl
    }
    urlRequest = URLRequest(url: url)
    urlRequest.addValue(request.contentType, forHTTPHeaderField: "Content-Type")
    request.additionalHeaders.forEach { key, value in
      urlRequest.addValue(value, forHTTPHeaderField: key)
    }
    if let user = currentUser?.id, let password = currentUser?.password {
      let auth = "\(user): \(password)"
      let authString = auth.data(using: .utf8)!.base64EncodedString()
      urlRequest.setValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
    }
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
