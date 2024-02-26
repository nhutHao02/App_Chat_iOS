//
//  AuthView.swift
//  AppChat
//
//  Created by TranHao on 25/02/2024.
//

import SwiftUI

struct AuthView: View {
    @State private var isLoginMode = true
    @State private var email: String = ""
    @State private var passwd: String = ""
    @State private var fullName: String = ""
    @State private var repeatPasswd: String = ""
    @State private var sex: Bool = true
    @State var showImagePicker = false
    @State var imageSelected: UIImage?
    
    @ObservedObject var authViewModel = AuthViewModel()
    
    
    var body: some View {
        ScrollView{
            VStack{
                // tab bar
                Picker(selection: $isLoginMode) {
                    Text("Log In")
                        .tag(true)
                    Text("Sign Up")
                        .tag(false)
                } label: {
                    Text("Picker here")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // input content
                if isLoginMode {
                    inputLogin
                        .transition(.opacity)
                } else {
                    inputSignUp
                        .transition(.opacity)
                }
                // Button
                Button {
                    if isLoginMode {
                        authViewModel.login(withEmail: email, passwd: passwd)
                    } else {
                        authViewModel.signUp(withEmail: email, passwd: passwd, fullName: fullName, image: imageSelected)
                    }
                    
                } label: {
                    HStack{
                        Spacer()
                        Text(isLoginMode ? "Log In" : "Sign Up")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                        Spacer()
                    }
                }
                .background(.blue)
                .cornerRadius(5)
                .padding(.vertical, 10)
                .alert(isPresented: $authViewModel.isShowAler) {
                    Alert(title: Text("Alert Dialog"), message: Text(authViewModel.statusMessage), dismissButton: .default(Text("OK")))
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(isLoginMode ? "Login" : "Create Account")
        .background(.gray.opacity(0.25))
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $imageSelected, showPickerImage: $showImagePicker)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AuthView()
        }
    }
}
extension AuthView {
    var inputLogin: some View {
        VStack{
            CustomTextFieldAuthView(text: $email, isSecure: false, iconName: "envelope", placeholder: "Email")
            CustomTextFieldAuthView(text: $passwd, isSecure: true, iconName: "lock", placeholder: "Password")
        }
    }
    var inputSignUp: some View {
        VStack{
            Group{
                if imageSelected != nil {
                    Image(uiImage: imageSelected!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "photo.circle")
                        .font(.system(size: 80))
                        .padding()
                }
            }
            .onTapGesture {
                showImagePicker.toggle()
            }
            
            CustomTextFieldAuthView(text: $fullName, isSecure: false, iconName: "person", placeholder: "Full Name")
            CustomTextFieldAuthView(text: $email, isSecure: false, iconName: "envelope", placeholder: "Email")
            CustomTextFieldAuthView(text: $passwd, isSecure: true, iconName: "lock", placeholder: "Password")
            CustomTextFieldAuthView(text: $repeatPasswd, isSecure: true, iconName: "lock", placeholder: "Repeat Password")
        }
    }
    
}
