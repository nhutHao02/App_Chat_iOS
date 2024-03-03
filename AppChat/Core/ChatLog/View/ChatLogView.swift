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
    @State private var showImagePicker = false
    
    @ObservedObject var viewModel: ChatLogViewModel
    
    init(user: User?) {
        self.user = user
        self.viewModel = ChatLogViewModel(user: user)
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView{
                ScrollViewReader { proxy in
                    VStack{
                        ForEach(viewModel.chatMessages){ mess in
                            if mess.fromUid == Auth.auth().currentUser?.uid {
                                // message Sender
                                HStack{
                                    Spacer()
                                    if mess.urlImgMess == "" {
                                        // mesage is text
                                        HStack{
                                            MessageTextView(content: mess.content)
                                        }
                                    } else {
                                        // message is imgage
                                        HStack{
                                            MessageImageView(urlString: mess.urlImgMess, width: 300, height: 200)                                                 .padding(.vertical, 10)
                                        }
                                        .padding(.vertical, 10)
                                    }
                                }
                                .padding(.horizontal, 10)
                                
                            } else {
                                // message Receiver
                                HStack{
                                    // image recender
                                    VStack{
                                        Spacer()
                                        if user?.urlIMG == "" {
                                            ImageUserView(nameIMG: "person.fill", typeIMG: false, size: 30)
                                        } else {
                                            ImageUserView(nameIMG: (user?.urlIMG)!, typeIMG: true, size: 30)
                                        }
                                    }
                                    // message
                                    if mess.urlImgMess == "" {
                                        // mesage is text
                                        HStack{
                                            MessageTextView(content: mess.content)
                                        }
                                    } else {
                                        // message is imgage
                                        HStack{
                                            MessageImageView(urlString: mess.urlImgMess, width: 300, height: 200)
                                        }
                                        .padding(.vertical, 10)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                        HStack{ Spacer() }
                            .id("Last")
                            .padding(.bottom, 80)
                    }
                    .onReceive(viewModel.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            proxy.scrollTo("Last", anchor: .bottom)
                        }
                    }
                }
            }
            actionBar
        }
        .navigationTitle(user?.fullName ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: user?.urlIMG == "" ?  ImageUserView(nameIMG: "person.fill", typeIMG: false, size: 40) : ImageUserView(nameIMG: (user?.urlIMG)!, typeIMG: true, size: 40) )
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ChatLogView(user: User(uid: "", email: "", fullName: "TranNhutHao", pass: "", urlIMG: ""))
        }
    }
}
extension ChatLogView {
    var actionBar: some View {
        HStack(spacing: 5){
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 29))
                .foregroundColor(Color(.darkGray))
            
                .onTapGesture {
                    showImagePicker.toggle()
                }
            TextField(" Aa", text: $viewModel.textInput)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
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
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $viewModel.imageSelected, showPickerImage: $showImagePicker)
        }
    }
}
