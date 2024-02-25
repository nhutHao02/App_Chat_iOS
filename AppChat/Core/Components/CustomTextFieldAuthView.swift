//
//  CustomTextFieldAuthView.swift
//  AppChat
//
//  Created by TranHao on 25/02/2024.
//

import SwiftUI

struct CustomTextFieldAuthView: View {
    @Binding var text: String
    let isSecure: Bool
    let iconName: String
    let placeholder: String
    var body: some View {
        HStack{
            Group{
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(width: 25, height: 25)
               if isSecure {
                    SecureField(placeholder, text: $text)
                       .font(.title2)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.title2)
                }
            }
            .padding(6)
         }
        .background(.white)
        .cornerRadius(5)
       
    }
}

struct CustomTextFieldAuthView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldAuthView(text: .constant(""), isSecure: true, iconName: "ss", placeholder: "ss")
            
    }
}
