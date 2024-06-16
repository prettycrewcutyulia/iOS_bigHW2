//
//  LoginResult.swift
//  ScrabbleGame
//
//  Created by Ярослав Гамаюнов on 17.06.2024.
//

import Foundation

enum LoginResult {
    case success(id: String, token: String)
    case error(message: String)
}
