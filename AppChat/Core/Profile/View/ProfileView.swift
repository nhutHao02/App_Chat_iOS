//
//  ProfileView.swift
//  AppChat
//
//  Created by TranHao on 03/03/2024.
//

import SwiftUI

struct ProfileView: View {
    let user: User?
    @State var fullName: String = ""
    @State var passwd: String = ""
    @State private var isEditing: Bool = false
    @State private var isShowPass: Bool = false
    
    @ObservedObject var viewModel = ProfileViewModel()
    init(user: User?) {
        self.user = user
    }
    var body: some View {
        VStack{
            HStack(alignment: .center) {
                Spacer()
                if user?.urlIMG != "" {
                    ImageUserView(nameIMG: (user?.urlIMG)!, typeIMG: false, size: 110)
                } else {
                    ImageUserView(nameIMG: "person.fill", typeIMG: false, size: 110)
                }
                Spacer()
            }
            .padding(.top, 20)
            VStack(alignment: .leading){
                HStack{
                    Text("Full Name:")
                        .font(.title2)
                        .bold()
                        .frame(width: 110, alignment: .leading)
                    TextField("Full Name", text: $fullName)
                        .disabled(!isEditing)
                        .font(.title2)
                    Spacer()
                }
                HStack{
                    Text("Email:")
                        .font(.title2)
                        .bold()
                        .frame(width: 110, alignment: .leading)
                    Text(user?.email ?? "")
                        .disabled(true)
                        .font(.title2)
                    Spacer()
                }
                HStack{
                    Text("Password:")
                        .font(.title2)
                        .bold()
                        .frame(width: 110, alignment: .leading)
                    if isShowPass {
                        TextField("Password", text: $passwd)
                            .disabled(!isEditing)
                            .font(.title2)
                        
                    } else {
                        SecureField("Password", text: $passwd)
                            .disabled(!isEditing)
                            .font(.title2)
                    }
                    Spacer()
                    Image(systemName: isShowPass ? "eye.slash" : "eye")
                        .padding(.trailing, 30)
                        .onTapGesture {
                            isShowPass.toggle()
                        }
                }
                
            }
            .padding(.top, 50)
            .padding(.horizontal, 10)
            
            
            Spacer()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing{
                    Button {
                        viewModel.updateInfo(oldFullName: user!.fullName, oldPass: user!.pass, newFullName: fullName, newPass: passwd)
                        isEditing.toggle()
                    } label: {
                        Text("Save")
                    }
                } else {
                    Button {
                        isEditing.toggle()
                    } label: {
                        Text("Edit")
                    }
                }
            }
        }
        .onAppear {
            self.fullName = user?.fullName ?? ""
            self.passwd = user?.pass ?? ""
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ProfileView(user: User(uid: "", email: "ATanHao2gmail.com", fullName: "Hao Tranf", pass: "asdh12", urlIMG: ""))
        }
    }
}
