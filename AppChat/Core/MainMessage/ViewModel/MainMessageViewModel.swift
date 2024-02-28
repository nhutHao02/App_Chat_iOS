//
//  MainMessageViewModel.swift
//  AppChat
//
//  Created by TranHao on 27/02/2024.
//

import Foundation
import Firebase

class MainMessageViewModel: ObservableObject {
    @Published var userCurrent: User?
    @Published var isStatusSignOut = false {
        didSet{
            fetchUser()
        }
    }
    
    let service = UserService()
    init(){
        self.isStatusSignOut = Auth.auth().currentUser?.uid == nil
        fetchUser()
    }
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        self.service.fetchUser(withUid: uid) { user in
            self.userCurrent = user
        }
    }
    func signOut(){
        self.isStatusSignOut.toggle()
        try? Auth.auth().signOut()
    }
}
