//
//  RecentMessage.swift
//  AppChat
//
//  Created by TranHao on 02/03/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
struct RecentMessage: Decodable, Identifiable {
    @DocumentID var id:String?
    let fromUid, toUid, textRecent, fullName: String
    let timestamp: Timestamp
    let urlIMG: String
}
