//
//  User.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 15.06.2024.
//

import Foundation

// TODO: Создала сущность, так мне нужно использовать id пользователя.
// TODO: Кто занимается пользователями, используйте ее пожалуйста
struct User: Identifiable, Codable {
    let id: UUID
    let nickName: String
}
