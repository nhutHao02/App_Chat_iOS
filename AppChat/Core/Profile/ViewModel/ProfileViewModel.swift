//
//  ProfileViewModel.swift
//  AppChat
//
//  Created by TranHao on 03/03/2024.
//

import Foundation
import Firebase
class ProfileViewModel: ObservableObject {
    init() {
    }
    
    func updateInfo(oldFullName: String, oldPass: String, newFullName: String, newPass: String) {
        // chekc info dont change
        if oldFullName == newFullName && oldPass == newPass {
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var data: [String: Any] = [:]
        
        if oldFullName != newFullName {
            data["fullName"] = newFullName
        }
        if oldPass == newPass {
            data["pass"] = newPass
        }
        
        Firestore.firestore().collection("users").document(uid)
            .updateData(data) { error in
                if let err = error {
                    print("Error when change infomation user: \(err)")
                    return
                }
            }
    }
}
