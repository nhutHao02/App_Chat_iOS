//
//  MessageTextView.swift
//  AppChat
//
//  Created by TranHao on 03/03/2024.
//

import SwiftUI

struct MessageTextView: View {
    let content: String

    var body: some View {
        Text(content)
            .padding()
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(5)
    }
}

//struct MessageTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageTextView()
//    }
//}
