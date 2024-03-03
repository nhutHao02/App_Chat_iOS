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
    @Published var recentMessages: [RecentMessage] = []
    @Published var isStatusSignOut = false {
        didSet{
            fetchUser()
            self.recentMessages = []
            fetchRecentMessages()
        }
    }
    
    let service = UserService()
    
    init(){
        self.isStatusSignOut = Auth.auth().currentUser?.uid == nil
        self.fetchUser()
        self.fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("recent_messages")
            .document(uid)
            .collection("message")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let err = error {
                    print("Error when fetch Recent Messsage: \(err)")
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    if let recentMessage = try? change.document.data(as: RecentMessage.self) {
                        self.recentMessages.insert(recentMessage, at: 0)
                    }
                    
                })
            }
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
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        if !uid.isEmpty {
            service.fetchUser(withUid: uid) { user in
                completion(user)
            }
        }
    }
    func calculatorDateRecent(time timestamp: Timestamp) -> String {
        let currentDate = Date()
        let dateFromTimestamp = timestamp.dateValue()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: dateFromTimestamp, to: currentDate)
        if let days = components.day, let hours = components.hour, let minutes = components.minute {
            if days > 0 {
                return "\(days) d"
            } else if hours > 0 {
                return "\(hours) h"
            } else if minutes > 0 {
                return "\(minutes) m"
            }
        }
        return ("now")
    }
}
