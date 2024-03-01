//
//  ChatMessage.swift
//  AppChat
//
//  Created by TranHao on 01/03/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
struct ChatMessage: Decodable, Identifiable{
    @DocumentID var id: String?
    let fromUid, toUid, content: String
    let timestamp: Timestamp
}
