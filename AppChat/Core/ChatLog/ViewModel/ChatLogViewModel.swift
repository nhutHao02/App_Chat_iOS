//
//  ChatLogViewModel.swift
//  AppChat
//
//  Created by TranHao on 01/03/2024.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseStorage
class ChatLogViewModel: ObservableObject {
    let user: User?
    
    @Published var chatMessages: [ChatMessage] = []
    @Published var textInput: String = ""
    @Published var count:Bool = false
    @Published var imageSelected: UIImage? {
        didSet {
            if imageSelected != nil {
                print("Image selected not null")
                handleSendImg()
            }
        }
    }
    
    let service = UserService()
    
    init(user: User?){
        self.user = user
        self.fetchChatMessage()
    }
    
    private func uploadImage(completion: @escaping(String, Bool) -> Void) {
        if let imageData = imageSelected?.jpegData(compressionQuality: 0.5) {
            let ref = Storage.storage().reference(withPath: UUID().uuidString)
            ref.putData(imageData) { metadata, error in
                if let err = error {
                    print("Error when sen Image at ChatLogView: \(err)")
                    self.imageSelected = nil
                    completion("", false)
                    return
                }
                ref.downloadURL { url, error in
                    if let err = error {
                        print("Error when downloadURL Firebase at ChatLogView: \(err)")
                        self.imageSelected = nil
                        completion("", false)
                        return
                    }
                    guard let urlImg = url else {
                        completion("", false)
                        return
                    }
                    print("Successfull store image with url: \(String(describing: url))")
                    self.imageSelected = nil
                    completion(urlImg.absoluteString, true)
                }
            }
        } else {
            print("Dont have image when Send message")
            completion("", false)
        }
        
    }
    
    func handleSendImg(){
        // formUid is uid of CurentUser sender
        guard let fromUid = Auth.auth().currentUser?.uid else {return}
        // toUid is uid of receiver
        guard let toUid = user?.uid else { return }
        uploadImage { url, success in
            if success == false {print("Error upload Image");return}
            let data: [String: Any] = [
                "fromUid": fromUid,
                "toUid": toUid,
                "content": self.textInput,
                "urlImgMess": url ,
                "timestamp": Timestamp()
            ]
            
            // save log sender side
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
                
                
            }
            
            // save log receiverside
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
            self.saveRecentMessage { succes in
                if succes {
                    self.textInput = ""
                    self.count.toggle()
                }
            }
            
        }
        
    }
    
    func handleSendMessage() {
        // formUid is uid of CurentUser sender
        guard let fromUid = Auth.auth().currentUser?.uid else {return}
        // toUid is uid of receiver
        guard let toUid = user?.uid else { return }
        
        let data: [String: Any] = [
            "fromUid": fromUid,
            "toUid": toUid,
            "content": self.textInput,
            "urlImgMess": "",
            "timestamp": Timestamp()
        ]
        
        // save log sender side
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
            
        }
        
        // save log receiverside
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
        self.saveRecentMessage { succes in
            if succes {
                self.textInput = ""
                self.count.toggle()
            }
        }
    }
    
    func saveRecentMessage(completion: @escaping(Bool) -> Void) {
        // formUid is uid of CurentUser sender
        guard let fromUid = Auth.auth().currentUser?.uid else {return}
        // toUid is uid of receiver
        guard let toUid = user?.uid else { return }
        
        let data: [String: Any] = [
            "fromUid": fromUid,
            "toUid": toUid,
            "textRecent": self.textInput != "" ? textInput : "This is an image 🌄",
            "fullName": user?.fullName ?? "",
            "urlIMG": user?.urlIMG ?? "",
            "timestamp": Timestamp()
        ]
        // save recent message sender side
        let documentRecentFrom = Firestore.firestore().collection("recent_messages")
            .document(fromUid)
            .collection("message")
            .document(toUid)
        documentRecentFrom.setData(data) { error in
            if let err = error {
                print("Error save recent message form userCurrent: \(err)")
                completion(false)
                return
            }
        }
        
        // save recent message receiver side
        service.fetchUser(withUid: fromUid) { us in
            let dataOfReceiver: [String: Any] = [
                "fromUid": toUid,
                "toUid": fromUid,
                "textRecent": self.textInput != "" ? self.textInput : "This is an image 🌄",
                "fullName": us.fullName,
                "urlIMG": us.urlIMG ?? "",
                "timestamp": Timestamp()
            ]
            let documentRecentReceiver = Firestore.firestore().collection("recent_messages")
                .document(toUid)
                .collection("message")
                .document(fromUid)
            documentRecentReceiver.setData(dataOfReceiver) { error in
                if let err = error {
                    print("Error save recent message form userCurrent: \(err)")
                    completion(false)
                    return
                }
            }
            completion(true)
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
            .order(by: "timestamp")
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
            }
    }
    
}
