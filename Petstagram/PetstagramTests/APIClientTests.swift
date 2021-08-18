//
//  APIClientTests.swift
//  APIClientTests
//
//  Created by Hao Qin on 8/15/21.
//

import XCTest
import Swifter
import Combine
@testable import Petstagram

class APIClientTests: XCTestCase {
  
  var server = HttpServer()
  
  override func setUpWithError() throws {
    server.notFoundHandler = { [weak self] request in
      let attachment = XCTAttachment(string: "\(request.method) on \(request.path) requested, but not found")
      attachment.name = "Unhandled API path requested"
      attachment.lifetime = .keepAlways
      self?.add(attachment)
      return .notFound
    }
    
    do {
      try server.start()
    } catch {
      XCTFail("Could not start Swifter")
    }
  }
  
  override func tearDownWithError() throws {
    server.stop()
  }
  
  func testPublisherForRequest() {
    server.GET["/api/v1/posts"] = { _ in HttpResponse.ok(.text(JsonData.goodFeed)) }
    
    let request = PostRequest()
    let client = APIClient(environment: .local)
    
    var networkResult: Subscribers.Completion<Error>?
    var fetchedPosts: [Post]?
    let networkExpectation = expectation(description: "Network request")
    
    let cancellable = client.publisherForRequest(request)
      .sink { result in
        networkResult = result
        XCTAssertTrue(Thread.current.isMainThread, "Network completion called on background thread")
        networkExpectation.fulfill()
      } receiveValue: { newPosts in
        fetchedPosts = newPosts
      }

    wait(for: [networkExpectation], timeout: 3)
    cancellable.cancel()
    
    guard let result = networkResult else {
      XCTFail("No result from netwrok request")
      return
    }
    
    switch result {
    case .finished:
      XCTAssertEqual(fetchedPosts?.count ?? 0, 3)
    case .failure(let error):
      XCTFail(error.localizedDescription)
    }
  }
}
