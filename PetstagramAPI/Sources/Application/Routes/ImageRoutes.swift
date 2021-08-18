//
//  ImageRoutes.swift
//  ImageRoutes
//
//  Created by Hao Qin on 8/17/21.
//

import Foundation
import Kitura

func initializeImageRoutes(app: App) throws {
  let fileServer = try setUpFileServer()
  app.router.get("/api/v1/images", middleware: fileServer)
  app.router.post("/api/v1/image") { request, reponse, next in
    defer { next() }
    
    guard let filename = request.headers["Slug"] else {
      reponse.status(.preconditionFailed).send("Filename not specified")
      return
    }
    
    var imageDate = Data()
    do {
      try _ = request.read(into: &imageDate)
    } catch let readError {
      reponse.status(.internalServerError).send("Unable to read image data: \(readError.localizedDescription)")
      return
    }
    
    do {
      let fullPath = "\(fileServer.absoluteRootPath)/\(filename)"
      let fileUrl = URL(fileURLWithPath: fullPath)
      try imageDate.write(to: fileUrl)
      reponse.status(.created).send("Image created")
    } catch let writeError {
      reponse.status(.internalServerError).send("Unable to write image data: \(writeError)")
      return
    }
  }
}

private func setUpFileServer() throws -> StaticFileServer {
  let cacheOptions = StaticFileServer.CacheOptions(maxAgeCacheControlHeader: 3600)
  let options = StaticFileServer.Options(cacheOptions: cacheOptions)
  let fileServer = StaticFileServer(path: "images", options: options)
  try FileManager.default.createDirectory(atPath: fileServer.absoluteRootPath, withIntermediateDirectories: true, attributes: nil)
  return fileServer
}
