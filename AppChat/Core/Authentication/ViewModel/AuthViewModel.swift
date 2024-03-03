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
            // uploaf image to Storage Firebase
            if image != nil {
                self.uploadImageUser(withEmail: email, passwd: passwd, fullName: fullName, image: image)
            } else {
                self.saveUserInfo(withEmail: email, passwd: passwd, fullName: fullName, url: "")
            }
            
            print("Successful create User uid: \(String(describing: result?.user.uid))")
            self.statusMessage = "Successful create User"
            self.isShowAler = true
        }
    }
    private func uploadImageUser(withEmail email: String, passwd: String, fullName: String, image: UIImage?) {
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
                
                // save Info user to FireStorage Firebase
                guard let urlImg = url else {return}
                self.saveUserInfo(withEmail: email, passwd: passwd, fullName: fullName, url: urlImg.absoluteString)
            }
        }
    }
    
    private func saveUserInfo(withEmail email: String, passwd: String, fullName: String, url: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let data: [String: Any] = [
            "uid": uid,
            "email": email,
            "pass": passwd,
            "fullName": fullName,
            "urlIMG": url
        ]
        Firestore.firestore().collection("users").document(uid).setData(data) { error in
            if let err = error {
                print("Error ------- \(err)")
                return
            }
            print("Successful save user to FireStorage")
        }
        
    }
    
    func login(withEmail email: String, passwd: String, completion: @escaping (Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: passwd) { result, error in
            if let err = error{
                self.isShowAler = true
                self.statusMessage = "Error when login User with bug: \(err)"
                return
            }
            print("Successful login with User uid: \(String(describing: result?.user.uid))")
            completion(true)
        }
    }
    
}

