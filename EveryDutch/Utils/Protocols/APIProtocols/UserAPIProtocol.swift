//
//  UserAPIProtocol.swift
//  EveryDutch
//
//  Created by 계은성 on 1/15/24.
//

import Foundation

protocol UserAPIProtocol: EditScreenAPIType {
    
//    func readMyUserData() async throws -> [String: User]
    
    func readMyUserData() async throws -> User
    
    
    func readUser(uid: String) async throws -> [String: User]
    
    func searchUser(_ userID: String) async throws -> [String: User]
    
    func checkLogin() async throws
    func signInAnonymously() async throws
    
    func updateUserProfileImage(
        imageUrl: String
    ) async throws
}
