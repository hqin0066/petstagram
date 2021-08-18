//
//  CommentCell.swift
//  CommentCell
//
//  Created by Hao Qin on 8/16/21.
//

import SwiftUI

struct CommentCell: View {
  var post: Post
  
  let formatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .named
    formatter.unitsStyle = .short
    return formatter
  }()
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "person.circle")
          .resizable()
          .scaledToFit()
          .frame(width: 40)
          .clipShape(Circle())
        
        VStack(alignment: .leading) {
          Text(post.createdByUser)
            .font(.headline)
            .foregroundColor(.accentGreen)
          
          Text(formatter.localizedString(for: post.createdAt, relativeTo: Date()))
            .font(.caption)
        }
        
        Spacer()
      }
      
      Text(post.caption)
    }
    .padding(.bottom, 20)
  }
}

struct CommentCell_Previews: PreviewProvider {
  static var previews: some View {
    let activity = Date().advanced(by: TimeInterval(exactly: -5*60)!)
    let comment = "Can you take me to a walk?"
    let user = "hqin0066"
    let post = Post(caption: comment, createdAt: activity, createdByUser: user)
    CommentCell(post: post)
      .previewLayout(.fixed(width: 500, height: 200))
  }
}
