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
    @State private var paswd: String = ""
    @State private var fullName: String = ""
    @State private var repeatPasswd: String = ""
    @State private var sex: Bool = true
    
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
                    authViewModel.actionButton(typeButton: isLoginMode)
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
            }
            .padding(.horizontal)
        }
        .navigationTitle(isLoginMode ? "Login" : "Create Account")
        .background(.gray.opacity(0.25))
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
            CustomTextFieldAuthView(text: $paswd, isSecure: true, iconName: "lock", placeholder: "Password")
        }
    }
    var inputSignUp: some View {
        VStack{
            Image(systemName: "person.circle")
                .font(.system(size: 65))
                .padding()
            
            CustomTextFieldAuthView(text: $fullName, isSecure: false, iconName: "person", placeholder: "Full Name")
            CustomTextFieldAuthView(text: $email, isSecure: false, iconName: "envelope", placeholder: "Email")
            CustomTextFieldAuthView(text: $paswd, isSecure: true, iconName: "lock", placeholder: "Password")
            CustomTextFieldAuthView(text: $repeatPasswd, isSecure: true, iconName: "lock", placeholder: "Repeat Password")
        }
    }
    
}
