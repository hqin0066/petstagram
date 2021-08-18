//
//  FeedCell.swift
//  FeedCell
//
//  Created by Hao Qin on 8/16/21.
//

import SwiftUI
import Combine

struct FeedCell: View {
  var post: Post
  
  @State var postImage: UIImage? = nil
  @State private var subcriptions: Set<AnyCancellable> = []
  
  var body: some View {
    VStack {
      if let image = postImage {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .cornerRadius(15)
          .overlay({
            VStack(spacing: 20) {
              Button {
                
              } label: {
                Image("filled")
              }
              
              Button {
                
              } label: {
                Image("comment")
              }
              
              Button {
                
              } label: {
                Image("share")
              }
            }
            .padding()
            .shadow(radius: 3)
          }(), alignment: .bottomTrailing)
      } else {
        Image(systemName: "photo")
          .resizable()
          .scaledToFit()
          .foregroundColor(.accentGreen.opacity(0.2))
          .onAppear {
            guard let imageId = self.post.id else { return }
            let client = APIClient()
            let request = DownloadImageRequest(imageId: imageId)
            client.publisherForRequest(request)
              .replaceError(with: UIImage(systemName: "photo")!)
              .sink { image in
                self.postImage = image
              }
              .store(in: &subcriptions)
          }
      }
      
      CommentCell(post: post)
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct FeedCell_Previews: PreviewProvider {
  static var previews: some View {
    let createdDate = Date().advanced(by: TimeInterval(exactly: -5*50)!)
    let post = Post(caption: "Can you take me to a walk?", createdAt: createdDate, createdByUser: "UserName")
    
    Group {
      FeedCell(post: post)
        .previewLayout(.fixed(width: 500, height: 500))
      FeedCell(post: post, postImage: UIImage(named: "dada")!)
        .previewLayout(.fixed(width: 500, height: 500))
    }
  }
}
