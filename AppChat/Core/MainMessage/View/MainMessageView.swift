//
//  MainMessageView.swift
//  AppChat
//
//  Created by TranHao on 27/02/2024.
//

import SwiftUI

struct MainMessageView: View {
    @State var showSignOutOptions = false
    @State var isShowCreateNewMessage = false
    @State var isNavigateToChatLogView = false
    @State var userChatSelected:User?
    
    @ObservedObject var viewModel = MainMessageViewModel()
    
    var body: some View {
        VStack{
            // custom bar
            customBar
            messageHistory
            NavigationLink("", isActive: $isNavigateToChatLogView) {
                ChatLogView(user: userChatSelected)
            }
        }
        .overlay(alignment: .bottom, content: {
            buttonAdd
        })
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, -44)
        .fullScreenCover(isPresented: $viewModel.isStatusSignOut) {
            AuthView()
        }
    }
}


struct MainMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainMessageView()
        }
//        NavigationView{
//            MainMessageView()
//                .preferredColorScheme(.dark)
//        }
    }
}
extension MainMessageView {
    var customBar: some View {
        HStack{
            if let url = viewModel.userCurrent?.urlIMG {
                if url != "" &&  url != " "{
                    ImageUserView(nameIMG: url, typeIMG: true, size: 50)
                } else {
                    ImageUserView(nameIMG: "person.fill", typeIMG: false, size: 50)
                }
            }

            VStack(alignment: .leading, spacing: 2){
                Text(viewModel.userCurrent?.fullName ?? " ")
                    .font(.system(size: 24))
                    .bold()
                HStack{
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.green)
                    Text("Online")
                        .font(.system(size: 12))
                }
            }
            Spacer()
                Button {
                    showSignOutOptions.toggle()
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 25))
                }
        }
        .padding(.horizontal, 10)
        .actionSheet(isPresented: $showSignOutOptions) {
            ActionSheet(
                title: Text("Settings"),
                message: Text("What đo you want to do?"),
                buttons: [.destructive(Text("Sign Out"), action: {
                    // Sign out
                    viewModel.signOut()
                }), .cancel()])
        }
    }
    
    var buttonAdd: some View {
        Button {
            isShowCreateNewMessage.toggle()
        } label: {
            HStack(alignment: .center){
                Spacer()
                Text("+ New Message")
                    .foregroundColor(.white)
                
                Spacer()
            }
            .frame(height: 38)
            .background(.blue)
            .cornerRadius(30)
            .padding(.horizontal, 10)
        }
        .fullScreenCover(isPresented: $isShowCreateNewMessage) {
            NewMassageView { user in
                userChatSelected = user
                isNavigateToChatLogView = true
            }
        }
    }
    var messageHistory: some View {
        ScrollView{
            LazyVStack{
                ForEach(0 ..< 20, id: \.self){ _ in
                    HStack{
                        Image(systemName: "person.fill")
                            .font(.system(size: 34))
                            .overlay(Circle().stroke(Color(.label), lineWidth: 1))
                        VStack(alignment: .leading, spacing: 4){
                            Text("User Name")
                                .font(.system(size: 16))
                                .bold()
                            Text("This was message to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()
                        Text("22d")
                    }
                    Divider()
                }
                .padding(.horizontal, 10)
            }
            .padding(.bottom, 40)
        }

    }
}
