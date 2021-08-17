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
      "id": "9594E968-574D-4218-9A38-43252FBDB648",
      "createdAt": "2020-04-01T12:00:00Z",
      "caption": "Living her best life! #corgi #puppyStyle",
      "createdByUser": "hqin0066"
    },
    {
      "id": "FE4F52F3-5CF2-4A07-98AA-4D42B9D12F64",
      "createdAt": "2020-03-11T04:44:00Z",
      "caption": "Bath time is best time!",
      "createdByUser": "PetLog"
    },
    {
      "id": "FBA357ED-21ED-4714-9689-F33F997801C7",
      "createdAt": "2020-01-03T17:32:00Z",
      "caption": "Not sure if alien or dog...",
      "createdByUser": "FoodDraw2021"
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
