//
//  MessageImageView.swift
//  AppChat
//
//  Created by TranHao on 03/03/2024.
//

import SwiftUI

struct MessageImageView: View {
  let urlString: String
  let width: CGFloat
  let height: CGFloat

  var body: some View {
    AsyncImage(url: URL(string: urlString), content: { image in
      image
        .resizable()
        .scaledToFill()
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(width: width, height: height)
    }, placeholder: {
      ProgressView()
    })
  }
}

//struct MessageImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageImageView()
//    }
//}
