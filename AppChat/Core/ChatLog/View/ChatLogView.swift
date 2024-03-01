//
//  ChatLogView.swift
//  AppChat
//
//  Created by TranHao on 01/03/2024.
//

import SwiftUI
import Firebase

struct ChatLogView: View {
    let user: User?
    
    @ObservedObject var viewModel: ChatLogViewModel
    
    init(user: User?) {
        self.user = user
        self.viewModel = ChatLogViewModel(user: user)
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView{
                LazyVStack{
                    ForEach(viewModel.chatMessages){ mess in
                        if mess.fromUid == Auth.auth().currentUser?.uid {
                            HStack{
                                Spacer()
                                Text(mess.content)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal, 10)
                        } else {
                            HStack{
                                Text(mess.content)
                                    .padding()
                                    .foregroundColor(Color(.label))
                                    .background(.gray.opacity(0.2))
                                    .cornerRadius(5)
                                Spacer()
                            }
                            .padding(.horizontal, 10)
                        }
                    
                    }
                }
                .padding(.bottom, 80)
            }
            
            HStack(spacing: 5){
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 29))
                    .foregroundColor(Color(.darkGray))
                TextField(" Aa", text: $viewModel.textInput)
                    .lineLimit(nil)
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color(.label), lineWidth: 1).opacity(0.4))
                Button {
                    viewModel.handleSendMessage()
                } label: {
                    Text("Send")
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                }

            }
            .padding()
            .background(.white)
        }
        .navigationTitle(user?.fullName ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ChatLogView(user: User(uid: "", email: "", fullName: "TranNhutHao", pass: "", urlIMG: ""))
        }
    }
}
