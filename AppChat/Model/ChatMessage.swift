//
//  ChatMessage.swift
//  AppChat
//
//  Created by TranHao on 01/03/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
struct ChatMessage: Decodable, Identifiable, Hashable{
    @DocumentID var id: String?
    let fromUid, toUid, content, urlImgMess: String
    let timestamp: Timestamp
}
