//
//  ChatLogViewModel.swift
//  AppChat
//
//  Created by TranHao on 01/03/2024.
//

import Foundation
import Firebase
class ChatLogViewModel: ObservableObject {
    let user: User?
    @Published var chatMessages: [ChatMessage] = []
    @Published var textInput: String = ""
    
    init(user: User?){
        self.user = user
        self.fetchChatMessage()
    }
    
    func handleSendMessage() {
        // formUid is uid of CurentUser sender
        guard let fromUid = Auth.auth().currentUser?.uid else {return}
        // toUid is uid of receiver
        guard let toUid = user?.uid else { return }
        
        let data: [String: Any] = [
            "fromUid": fromUid,
            "toUid": toUid,
            "content": textInput,
            "timestamp": Timestamp()
        ]
        
        let document = Firestore.firestore().collection("messages")
            .document(fromUid)
            .collection(toUid)
            .document()
        
        document.setData(data) { error in
            if let err = error {
                print("Error when Handle Send Message at document: \(err)")
                return
            }
            print("Successful save current user send message")
            self.textInput = ""
        }
        
        let receiveDocument = Firestore.firestore().collection("messages")
            .document(toUid)
            .collection(fromUid)
            .document()
        
        receiveDocument.setData(data) { error in
            if let err = error {
                print("Error when Handle Send Message at receiveDocument: \(err)")
                return
            }
            print("Successful save message at receiver")
        }
    }
    
    func fetchChatMessage() {
        // formUid is uid of CurentUser sender
        guard let fromUid = Auth.auth().currentUser?.uid else {return}
        // toUid is uid of receiver
        guard let toUid = user?.uid else { return }
        
        Firestore.firestore().collection("messages")
            .document(fromUid)
            .collection(toUid)
            .addSnapshotListener { querySnapshot, error in
                if let err = error {
                    print("Error when fetch ChatMessage: \(err)")
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        if let chatMessage = try? change.document.data(as: ChatMessage.self) {
                            self.chatMessages.append(chatMessage)
                        }
                    }
                })
                
                //                guard let documents = querySnapshot?.documents else { return }
                //                self.chatMessages = documents.compactMap({ try? $0.data(as: ChatMessage.self)})
            }
    }
    
}
