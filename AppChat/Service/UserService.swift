//
//  UserService.swift
//  AppChat
//
//  Created by TranHao on 27/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
struct UserService {
    func fetchUser(withUid uid: String, comletion: @escaping (User) -> Void) {
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let err = error {
                print("Failed fetchUser with error: \(err)")
                return
            }
            guard let snapshot = snapshot else {return}
            guard let user = try? snapshot.data(as: User.self) else {return}
            comletion(user)
        }
    }
}
