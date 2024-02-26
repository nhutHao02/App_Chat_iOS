//
//  AuthViewModel.swift
//  AppChat
//
//  Created by TranHao on 25/02/2024.
//

import Foundation
import Firebase
import UIKit
import FirebaseStorage
class AuthViewModel: ObservableObject {
    
    @Published var isShowAler = false
    var statusMessage = ""
    
    func signUp(withEmail email: String, passwd: String, fullName: String, image: UIImage?){
        Auth.auth().createUser(withEmail: email, password: passwd) { result, error in
            if let err = error{
                self.isShowAler = true
                self.statusMessage = "Error when create User with bug: \(err)"
                return
            }
            self.uploadImageUser(image: image)
            print("Successful create User uid: \(String(describing: result?.user.uid))")
            self.statusMessage = "Successful create User"
            self.isShowAler = true
        }
    }
    private func uploadImageUser(image: UIImage?) {
        // convert image to data
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else {return}
        
        // get uid currentUser
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Storage.storage().reference(withPath: uid)
        ref.putData(imageData) { metadata, error in
            if let err = error {
                self.statusMessage = "Error when put Image User: \(err)"
                return
            }
            ref.downloadURL { url, error in
                if let err = error {
                    self.statusMessage = "Error when downloadURL Firebase: \(err)"
                    return
                }
                print("Successfull store image with url: \(String(describing: url))")
            }
        }
        
        
        
    }
    
    func login(withEmail email: String, passwd: String){
        Auth.auth().signIn(withEmail: email, password: passwd) { result, error in
            if let err = error{
                self.isShowAler = true
                self.statusMessage = "Error when login User with bug: \(err)"
                return
            }
            print("Successful login with User uid: \(String(describing: result?.user.uid))")
        }
    }
}

