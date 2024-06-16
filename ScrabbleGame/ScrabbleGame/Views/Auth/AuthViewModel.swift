//
//  AuthViewModel.swift
//  ScrabbleGame
//
//  Created by Ярослав Гамаюнов on 17.06.2024.
//

import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var nickName: String = ""
    @Published var password: String = ""
    @Published var loginStatus: String = ""
    @Published var registerStatus: String = ""
    @Published var isLoggedIn: Bool = false
    
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func onAppear() {
         loadCurrentUser()
     }
     
    private func loadCurrentUser() {
        if (!UserDefaultsService.shared.isCurrentUserSaved()) {
            return
        }
        let currentUser = UserDefaultsService.shared.getCurrentUserSafe()
        if (currentUser == nil) {
            return
        }
        
        nickName = currentUser!.nickName
        let savedPass = UserDefaultsService.shared.getCurrentUserPassword()
        if (savedPass != nil) {
            password = savedPass!
            login()
        }
    }
    
    func register() {
        guard !nickName.isEmpty, !password.isEmpty else {
            registerStatus = "Fields cannot be empty."
            return
        }
        
        isLoading = true
        Task {
            do {
                let result = try await NetworkService.shared.registerUser(nickName: nickName, password: password)
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.registerStatus = "Registration successful."
                    case .error(let message):
                        self.registerStatus = message
                    }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.registerStatus = "Registration failed: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    func login() {
        guard !nickName.isEmpty, !password.isEmpty else {
            loginStatus = "Fields cannot be empty."
            return
        }
        
        isLoading = true
        Task {
            do {
                let result = try await NetworkService.shared.loginUser(nickName: nickName, password: password)
                DispatchQueue.main.async {
                    switch result {
                    case .success(let id, let token):
                        UserDefaultsService.shared.setCurrentUser(id: id, nickName: self.nickName, token: token,              password: self.password)
                        NetworkService.shared.setAuthToken(token: token)
                        self.loginStatus = "Login successful"
                        self.isLoggedIn = true
                    case .error(let message):
                        self.loginStatus = message
                    }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.loginStatus = "Login failed: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    func logout() {
        UserDefaultsService.shared.clearCurrentUser()
        isLoggedIn = false
        nickName = ""
        password = ""
        loginStatus = ""
        registerStatus = ""
    }
}
