//
//  User.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 15.06.2024.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let nickName: String
    let token: String
    
    static let Default = User(id: UUID(uuidString: "38B6A72A-4580-4736-B3EE-C33D3B060F6B")!, nickName: "", token: "")
}
