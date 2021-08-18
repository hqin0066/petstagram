//
//  CreatePostView.swift
//  CreatePostView
//
//  Created by Hao Qin on 8/16/21.
//

import SwiftUI

struct CreatePostView: View {
  @State private var postImage = UIImage()
  @State private var showNext = false
  
  var body: some View {
    NavigationView {
      VStack {
        TakePhotoView { image in
          postImage = image
          showNext = true
        }
        
        NavigationLink(isActive: $showNext) {
          Text("")
        } label: {
          EmptyView()
        }
      }
    }
  }
}

struct CreatePostView_Previews: PreviewProvider {
  static var previews: some View {
    CreatePostView()
  }
}
