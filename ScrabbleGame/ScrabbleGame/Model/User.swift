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
}
