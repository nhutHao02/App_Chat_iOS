//
//  User.swift
//  AppChat
//
//  Created by TranHao on 27/02/2024.
//

import Foundation
import FirebaseFirestoreSwift
struct User: Decodable, Identifiable {
    @DocumentID var id: String?
    let uid, email, fullName, pass: String
    let urlIMG: String?
    
}

