//
//  ImageUserView.swift
//  AppChat
//
//  Created by TranHao on 27/02/2024.
//

import SwiftUI

struct ImageUserView: View {
    let nameIMG: String
    let typeIMG: Bool
    let size: CGFloat
    
    var body: some View {
        if typeIMG {
            AsyncImage(url: URL(string: nameIMG)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: size, height: size)
                    .overlay(Circle().stroke(Color(.label), lineWidth: 0.5))
                
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(systemName: nameIMG)
                .resizable()
                .foregroundColor(.gray)
                .background(.white)
                .clipShape(Circle())
                .frame(width: size, height: size)
                .overlay(Circle().stroke(Color(.label), lineWidth: 0.5))
        }
    }
}

struct ImageUserView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUserView(nameIMG: "https://firebasestorage.googleapis.com:443/v0/b/app-chat-ios-swiftui.appspot.com/o/Gjc8F35DwUejMUkPF9uRudibErZ2?alt=media&token=a6919ff3-283f-4224-9567-3de057efc6c8", typeIMG: true, size: 60)
        //        ImageUserView(nameIMG: "person.fill", typeIMG: false, size: 30)
    }
}
