//
//  AuthView.swift
//  ScrabbleGame
//
//  Created by Ярослав Гамаюнов on 17.06.2024.
//

import Foundation

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack {
                    TextField("Nickname", text: $viewModel.nickName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    HStack {
                        Button(action: {
                            viewModel.register()
                        }) {
                            Text("Register")
                                .padding()
                                .background(.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            viewModel.login()
                        }) {
                            Text("Login")
                                .padding()
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    
                    Text(viewModel.registerStatus)
                        .foregroundColor(.red)
                        .padding()
                    
                    Text(viewModel.loginStatus)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .onAppear {
                viewModel.onAppear()
            }
            .navigationTitle("Login or Register")
            .background(
                NavigationLink(
                    destination: CreateGameRoomView(),
                    isActive: $viewModel.isLoggedIn
                ) {
                    EmptyView()
                }
            )
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
