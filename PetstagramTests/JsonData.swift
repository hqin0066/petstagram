//
//  JsonData.swift
//  JsonData
//
//  Created by Hao Qin on 8/15/21.
//

import Foundation

enum JsonData {
  static let goodFeed = """
  [
    {
      "imageUrl": "/photos/image1.jpg",
      "createdAt": "2020-04-01T12:00:00Z",
      "caption": "Living her best life! #corgi #puppyStyle"
    },
    {
      "imageUrl": "/photos/image1.jpg",
      "createdAt": "2020-03-11T04:44:00Z",
      "caption": "Bath time is best time!"
    },
    {
      "imageUrl": "/photos/image1.jpg",
      "createdAt": "2020-01-03T17:32:00Z",
      "caption": "Not sure if alien or dog..."
    },
  ]
  """
  
  static let badFeed = """
  [
    "bad json"
  ]
  """
  
  static let goodSignUp = """
    {
      "username": "username",
      "email": "email@example.com"
    }
  """
}
