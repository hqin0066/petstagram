/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import KituraContracts

struct UploadImageRequest: APIRequest {
  let imageId: UUID
  let imageData: Data

  init(imageId: UUID, imageData: Data) {
    self.imageId = imageId
    self.imageData = imageData
  }

  typealias Response = Void

  var method: HTTPMethod { return .POST }
  var path: String { return "/image" }
  var contentType: String { return "image/jpeg" }
  var additionalHeaders: [String : String] {
    return ["Slug": "\(imageId.uuidString).jpg"]
  }
  var body: Data? {
    return imageData
  }
  var params: EmptyParams? { return nil }

  func handle(response: Data) throws -> Void {
  }
}

struct DownloadImageRequest: APIRequest {
  var imageId: UUID
  
  init(imageId: UUID) {
    self.imageId = imageId
  }
  
  typealias Response = UIImage
  
  var method: HTTPMethod { return .GET }
  var path: String { return "/images/\(imageId.uuidString).jpg" }
  var contentType: String { return "image/jpeg" }
  var additionalHeaders: [String : String] { return [:] }
  var body: Data? { return nil }
  var params: EmptyParams? { return nil }
  
  func handle(response: Data) throws -> UIImage {
    guard let image = UIImage(data: response) else {
      throw APIError.postProcessingFailed(nil)
    }
    return image
  }
}
