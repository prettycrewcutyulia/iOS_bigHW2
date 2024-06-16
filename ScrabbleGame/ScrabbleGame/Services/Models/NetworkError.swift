//
//  NetworkError.swift
//  ScrabbleGame
//
//  Created by Ярослав Гамаюнов on 17.06.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case invalidResponse
    case serverError(message: String)
    case decodingError
}
