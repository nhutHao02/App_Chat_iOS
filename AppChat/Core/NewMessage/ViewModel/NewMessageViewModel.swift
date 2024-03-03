//
//  NewMessageViewModel.swift
//  AppChat
//
//  Created by TranHao on 28/02/2024.
//

import Foundation

class NewMessageViewModel: ObservableObject {
    @Published var users:[User] = []
    @Published var searchText = ""
    
    var searchedUser: [User] {
        if self.searchText.isEmpty {
            return users
        } else {
            let lowerCaseQuery = searchText.lowercased()
            return users.filter({
                $0.fullName.lowercased().contains(lowerCaseQuery)
            })
        }
    }
    let service = UserService()
    
    init() {
        self.fetchUsers()
    }
    
    func fetchUsers() {
        self.service.fetchUsers { users in
            self.users = users
        }
    }
}
